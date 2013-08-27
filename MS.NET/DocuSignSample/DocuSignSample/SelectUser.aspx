<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultPage.Master" AutoEventWireup="true" 
    CodeBehind="SelectUser.aspx.cs" Inherits="DocuSignSample.SelectUser" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="logo"> </div>
    <div class="row-fluid">

        <form id="logInForm" runat="server" class="form-signin">
            <fieldset>
                <legend>Log In</legend>

                <label for="DevCenterEmail">DevCenter E-mail</label>
                <input id="DevCenterEmail" type="text" name="DevCenterEmail" value="<%=email %>" disabled="true" />

                <label for="DevCenterPassword">Password</label>
                <input id="DevCenterPassword" type="password" name="DevCenterPassword" value="<%=password %>" disabled="true" />

                <label >Your Integrator Key</label>
                <input id="DevCenterIKey" type="text" name="DevCenterIKey" value="<%=key %>" disabled="true" />

                <label>Your Name</label>
                <select id="DevCenterName" name="DevCenterName">
                        <%
                            foreach (String name in names)
                            {
                                %>
                            <option value="<%=accounts[name].AccountID %>" ><%=accounts[name].UserName %> (<%=accounts[name].AccountName %>)</option>
                        <%
                            }
                        %>
                        </select>
                <div class="alert">
                     <span><b>Need a DevCenter Account?</b></span><br />
                            Get it <a href="http://www.docusign.com/developers-center/get-free-developer-account">
                                here</a>.
               </div>

                <div id="Div1" class="centeralign" style="width: 150px;">
                    <button class="btn btn-primary" runat="server" onserverclick="On_Login">Login</button>
                </div>
            </fieldset>
        </form>
    </div>
</asp:Content>
