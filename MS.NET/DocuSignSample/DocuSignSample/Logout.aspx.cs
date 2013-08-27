using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DocuSignSample.resources;

namespace DocuSignSample
{
    public partial class Logout : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Session[Keys.ApiAccountId] = null;
            Session[Keys.ApiEmail] = null;
            Session[Keys.ApiIkey] = null;
            Session[Keys.ApiPassword] = null;
            Session[Keys.EnvelopeIds] = null;

            Response.Redirect("Login.aspx", true);
        }
    }
}