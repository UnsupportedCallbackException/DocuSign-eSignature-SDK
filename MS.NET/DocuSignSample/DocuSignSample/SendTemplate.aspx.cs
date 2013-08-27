using DocuSignSample.resources;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;

namespace DocuSignSample
{
    public partial class SendTemplate : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!LoggedIn())
            {
                Response.Redirect("LogIn.aspx");
            }
            if (!Page.IsPostBack)
            {
                LoadTemplates();
            }
        }

        protected void CreateEnvelope(object sender, CommandEventArgs e)
        {
            // Create the envelope information
            var envelopeInfo = new DocuSignAPI.EnvelopeInformation
                {
                    Subject = txtSubject.Text,
                    EmailBlurb = txtEmailBlurb.Text,
                    AccountId = Session[Keys.ApiAccountId].ToString()
                };

            // Add any reminders
            if (!String.IsNullOrEmpty(Request.Form[Keys.Reminders]))
            {
                DateTime remind = Convert.ToDateTime(reminders.Value);
                int difference = (remind - DateTime.Today).Days;

                if (null == envelopeInfo.Notification)
                {
                    envelopeInfo.Notification = new DocuSignAPI.Notification();
                }
                envelopeInfo.Notification.Reminders = new DocuSignAPI.Reminders
                    {
                        ReminderEnabled = true,
                        ReminderDelay = difference.ToString(),
                        ReminderFrequency = "2"
                    };
            }

            // Add any expirations
            if (!String.IsNullOrEmpty(Request.Form[Keys.Expiration]))
            {
                DateTime expire = Convert.ToDateTime(expiration.Value);
                int difference = (expire - DateTime.Today).Days;

                if (null == envelopeInfo.Notification)
                {
                    envelopeInfo.Notification = new DocuSignAPI.Notification();
                }

                envelopeInfo.Notification.Expirations = new DocuSignAPI.Expirations
                    {
                        ExpireEnabled = true,
                        ExpireAfter = difference.ToString(),
                        ExpireWarn = (difference - 2).ToString()
                    };
            }

            // Get all the recipients
            var recipients = ConstructRecipients();

            // Construct the template reference
            var templateReference = new DocuSignAPI.TemplateReference
                {
                    TemplateLocation = DocuSignAPI.TemplateLocationCode.Server,
                    Template = Templates.Value,
                    RoleAssignments = CreateFinalRoleAssignments(recipients)
                };

            if (e.CommandName == "SendNow")
            {
                SendNow(templateReference, envelopeInfo, recipients);
            }
            else //Edit
            {
                EmbedSending(templateReference, envelopeInfo, recipients);
            }
        }

        protected void SendNow(DocuSignAPI.TemplateReference templateReference, DocuSignAPI.EnvelopeInformation envelopeInfo,
            DocuSignAPI.Recipient[] recipients)
        {
            DocuSignAPI.APIServiceSoapClient client = CreateAPIProxy();
            try
            {
                // Create the envelope using the specified template, and send it (note the last parameter)
                DocuSignAPI.EnvelopeStatus status = client.CreateEnvelopeFromTemplates(new DocuSignAPI.TemplateReference[] { templateReference },
                recipients, envelopeInfo, true);

                AddEnvelopeID(status.EnvelopeID);
                if (status.SentSpecified)
                {
                    Response.Redirect("GetStatusAndDocs.aspx", false);
                }

            }
            catch (Exception ex)
            {
                GoToErrorPage(ex.Message);
            }
        }

        protected void EmbedSending(DocuSignAPI.TemplateReference templateReference, DocuSignAPI.EnvelopeInformation envelopeInfo,
            DocuSignAPI.Recipient[] recipients)
        {
            DocuSignAPI.APIServiceSoapClient client = CreateAPIProxy();
            try
            {
                // Create the envelope using the specified template, but don't send it (note the last parameter)
                DocuSignAPI.EnvelopeStatus status = client.CreateEnvelopeFromTemplates(new DocuSignAPI.TemplateReference[] { templateReference },
                recipients, envelopeInfo, false);
                AddEnvelopeID(status.EnvelopeID);

                // If it created successfully, redirect to the embedded host
                if (DocuSignAPI.EnvelopeStatusCode.Created == status.Status)
                {
                    string navURL = String.Format("{0}?envelopeID={1}&accountID={2}&source=Template", "EmbeddedHost.aspx", status.EnvelopeID,
                        envelopeInfo.AccountId);

                    Response.Redirect(navURL, false);
                }
            }
            catch (Exception ex)
            {
                GoToErrorPage(ex.Message);
            }
        }

        protected DocuSignAPI.Recipient[] ConstructRecipients()
        {
            var runningList = new List<DocuSignAPI.Recipient>();

            // Create all the recipients on the template's envelope
            for (int i = 1; i <= Request.Form.Count; i++)
            {
                if (null == Request.Form[Keys.RecipientRole + i])
                {
                    continue;
                }
                var r = new DocuSignAPI.Recipient
                    {
                        UserName = Request.Form[Keys.RecipientName + i].ToString(),
                        Email = Request.Form[Keys.RecipientEmail + i].ToString(),
                        ID = i.ToString(),
                        RoleName = Request.Form[Keys.RecipientRole + i],
                        Type = DocuSignAPI.RecipientTypeCode.Signer
                    };

                if (null == Request.Form[Keys.RecipientInviteToggle + i])
                {
                    // we want an embedded signer
                    r.CaptiveInfo = new DocuSignAPI.RecipientCaptiveInfo {ClientUserId = i.ToString()};
                }
                runningList.Add(r);
               
            }

            return runningList.ToArray();
        }

        protected DocuSignAPI.TemplateReferenceRoleAssignment[] CreateFinalRoleAssignments(DocuSignAPI.Recipient[] recipients)
        {
            // Match up all the recipients to the roles on the template
            return recipients.Select(recipient => new DocuSignAPI.TemplateReferenceRoleAssignment
                {
                    RecipientID = recipient.ID, RoleName = recipient.RoleName
                }).ToArray();
        }

        protected void LoadTemplates()
        {
            DocuSignAPI.APIServiceSoapClient client = CreateAPIProxy();
            DocuSignAPI.EnvelopeTemplateDefinition[] templates = null;

            // Load all the template the logged in user has on their account
            try
            {
                templates = client.RequestTemplates(Session[Keys.ApiAccountId].ToString(), true);
                // Add them to the drop-down select
                foreach (DocuSignAPI.EnvelopeTemplateDefinition template in templates)
                {
                    Templates.Items.Add(new ListItem("Template " + template.TemplateID + ": " + template.Name, template.TemplateID));
                }
            }
            catch (Exception ex)
            {
                GoToErrorPage(ex.Message);
            }


        }

        protected void OnTemplateSelect(object src, EventArgs e)
        {
            // Request the template and populate the recipient table
            DocuSignAPI.APIServiceSoapClient client = CreateAPIProxy();
            try
            {
                DocuSignAPI.EnvelopeTemplate template = client.RequestTemplate(Templates.Value, false);
                // Populate the recipient UI
                AddRecipients(template.Envelope.Recipients);
            }
            catch (Exception ex)
            {
                GoToErrorPage(ex.Message);
            }


        }

        // Add the recipients to the UI
        protected void AddRecipients(DocuSignAPI.Recipient[] recipients)
        {
            int i = 1;
            foreach (DocuSignAPI.Recipient recipient in recipients)
            {
                var row = new HtmlTableRow();
                var roleCell = new HtmlTableCell();
                var nameCell = new HtmlTableCell();
                var emailCell = new HtmlTableCell();
                var securityCell = new HtmlTableCell();
                var inviteCell = new HtmlTableCell();

                roleCell.InnerHtml = String.Format(
                    "<input id='{0}' type='text' readonly='true' name='{0}{1}' value='{2}' />", 
                    Keys.RecipientRole, i, recipient.RoleName);

                nameCell.InnerHtml = String.Format(
                    "<input id='{0}' type='text' name='{0}{1}' value='{2}'/>", 
                    Keys.RecipientName, i, recipient.UserName);

                emailCell.InnerHtml = String.Format(
                    "<input id='{0}' type='text' name='{0}{1}' value='{2}'/>",
                    Keys.RecipientEmail, i, recipient.Email);

                string security = String.Empty;
                if (!String.IsNullOrEmpty(recipient.AccessCode))
                {
                    security = "Access code: " + recipient.AccessCode;
                }
                else if (null != recipient.PhoneAuthentication)
                {
                    security = "Phone Authentication";
                }
                else if (recipient.RequireIDLookup)
                {
                    security = "ID Check";
                }
                else
                {
                    security = "None";
                }

                securityCell.InnerHtml = String.Format(
                    "<input id='{0}' type='text' readonly='readonly' name='{0}{1}' value='{2}' />",
                    Keys.RecipientSecurity, i, security);

                var inviteData = "<div class='btn-group' data-toggle='buttons-radio'>"+
		            "<button type='button' class='btn active' >ON</button>"+
		            "<button type='button' class='btn' >OFF</button>"+
	                "</div>"+
	                "<input id='RecipientInviteToggle{1}' name='RecipientInviteToggle{1}' value='RecipientInviteToggle{1}' type='checkbox' checked style='visibility:hidden;'/>";

                inviteCell.InnerHtml = String.Format(inviteData,
                    Keys.RecipientInvite, i);

                inviteCell.Attributes[Keys.Id] = String.Format("{0}{1}", Keys.RecipientInvite,recipient.ID);
                inviteCell.Attributes[Keys.Name] = String.Format("{0}{1}", Keys.RecipientInvite,recipient.ID);

                row.Cells.Add(roleCell);
                row.Cells.Add(nameCell);
                row.Cells.Add(emailCell);
                row.Cells.Add(securityCell);
                row.Cells.Add(inviteCell);
                RecipientTable.Rows.Add(row);
                i++;
            }
        }
    }
}
