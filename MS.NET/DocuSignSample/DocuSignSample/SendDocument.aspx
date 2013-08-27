<%@ Page Title="Docusign: Send document" Language="C#" MasterPageFile="~/Tabs.Master" AutoEventWireup="true"
    CodeBehind="SendDocument.aspx.cs" Inherits="DocuSignSample.SendDocument" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <link rel="stylesheet" type="text/css" href="css/SendDocument.css" />
    <script type="text/javascript">
        $(document).ready(function () {

            var today = new Date();
            $("#reminders").datepicker({
                buttonImageOnly: true,
                minDate: today
            });
            $("#expiration").datepicker({
                buttonImageOnly: true,
                minDate: today + 3 * 24 * 60*60*1000
            });
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <form id="SendDocumentForm" action="SendDocument.aspx" runat="server" class="form-horizontal">
        <div class="row-fluid">
            <div class="span12">
                <asp:TextBox runat="server" type="text" id="txtSubject" name="subject" placeholder="enter the subject" autocomplete="off" class="span12" />
            </div>
        </div>
        <div class="row-fluid">
            <div class="span12">
                <asp:TextBox runat="server" id="txtEmailBlurb" cols="20" name="emailblurb" placeholder="enter the e-mail blurb"
                    rows="4" class="span12" TextMode="MultiLine" />
            </div>
        </div>
        <div class="row-fluid">
            <div class="span12">
                <table id="recipientList" name="recipientList" class="table">
                    <thead>
                        <tr class="recipientListHeader">
                            <th>Recipient</th>
                            <th>E-mail</th>
                            <th>Security and Setting</th>
                            <th>Send E-mail Invite</th>
                        </tr>
                    </thead>
                    <tbody>
                    <tr >
                        <td>
                            <input type="text" name="RecipientName1" />
                        </td>
                        <td>
                            <input type="email" name="RecipientEmail1" />
                        </td>
                        <td width="270">
                            <select id="RecipientSecurity1" name="RecipientSecurity1" onchange="EnableDisableInput(1)" style="width:150px;">
                                <option value="None">None</option>
                                <option value="AccessCode">Access Code:</option>
                                <option value="PhoneAuthentication">Phone Authentication</option>
                                <option value="IDCheck">ID Check</option>
                            </select>
                            <input type="text" id="RecipientSecuritySetting1" name="RecipientSecuritySetting1"
                                style="display: none; width:100px" />
                        </td>
                        <td>
                            <div class="btn-group" data-toggle="buttons-radio">
                                <button type="button" class="btn active">ON</button>
                                <button type="button" class="btn">OFF</button>
                            </div>
                            <input id="RecipientInviteToggle1" name="RecipientInviteToggle1" value="RecipientInviteToggle1"
                                    type="checkbox" checked style="visibility:hidden;" />
                        </td>
                    </tr>
                        </tbody>
                </table>
                <button class="btn" type="button" onclick="addRowToTable()"><i class="icon-plus"></i> Add Recipient</button>
            </div>
        </div>

        <hr />

        <div id="files" class="row-fluid">
            <div class="span12">
                <p>
                    Document #1:
           
                    <input class="upload" id="file1" type="file" name="file1" runat="server" />
                </p>
                <p>
                    Document #2:
           
                    <input class="upload" id="file2" type="file" name="file2" runat="server" />
                </p>
            </div>
        </div>
        <hr />
        <div class="row-fluid">
            <div class="span6">
                <label class="checkbox">
                    <input id="sendoption" class="options" type="checkbox" value="stockdoc" name="stockdoc"
                        onchange="EnableDisableDiv()" />
                    Use a stock doc
                   
                </label>
                <label class="checkbox">
                    <input class="options" type="checkbox" value="addsig" name="addsigs" checked />
                    Add Signatures
               
                </label>

                <label class="checkbox">
                    <input class="options" type="checkbox" value="addformfield" name="formfields" checked />
                    Add Form Fields
                    
                </label>

                <label class="checkbox">
                    <input class="options" type="checkbox" value="addcondfield" name="conditionalfields" checked />
                    Add Conditional Fields
                
                </label>
                <label class="checkbox">
                    <input class="options" type="checkbox" name="collabfields" value="addcollfield" />
                    Add Collaborative Fields
                </label>
                <label class="checkbox">
                    <input class="options" type="checkbox" name="enablepaper" value="enablepaper" />
                    Enable Signing on Paper
               
                </label>
                <label class="checkbox">
                    <input class="options" type="checkbox" name="signerattachment" value="reqattachment" />
                    Request a Signer to Add an Attachment
                </label>
                <label class="checkbox">
                    <input class="options" type="checkbox" name="markup" value="enablemarkup" />
                    Enable Signers to Mark Up the Documents
                </label>
            </div>
            <div class="span6">
                <label for="reminders">Add Daily Reminders</label>
                <div class="input-append">
                    <input type="text" id="reminders" class="datepickers" name="reminders" />
                    <span class="add-on"><label class="icon-calendar" for="reminders"></label></span>
                </div>
               <br />
                
                <label for="expiration">Add Expiration</label>
               
                <div class="input-append">
                    <input type="text" id="expiration" class="datepickers" name="expiration" />
                    <span class="add-on"><label class="icon-calendar" for="expiration"></label></span>
                </div>
                <br />
                
            </div>
        </div>
        <div class="row-fluid">
            <div class="span6">
                <button type="submit" class="btn btn-large btn-success span8 pull-right" runat="server" onserverclick="SendNow">Send Now</button>
            </div>
            <div class="span6">
                <button type="submit" class="btn btn-large btn-primary span8" runat="server" onserverclick="EmbedSending">Edit Before Sending</button>
            </div>
        </div>

    </form>
</asp:Content>
