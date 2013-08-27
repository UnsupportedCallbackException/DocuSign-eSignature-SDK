<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultPage.Master" AutoEventWireup="true"
    CodeBehind="Login.aspx.cs" Inherits="DocuSignSample.Login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
     <style type="text/css">
      body {
        padding-top: 40px;
        padding-bottom: 40px;
        background-color: #f5f5f5;
      }

      .form-signin {
        max-width: 250px;
        padding: 19px 29px 29px;
        margin: 0 auto 20px;
        background-color: #fff;
        border: 1px solid #e5e5e5;
        -webkit-border-radius: 5px;
           -moz-border-radius: 5px;
                border-radius: 5px;
        -webkit-box-shadow: 0 1px 2px rgba(0,0,0,.05);
           -moz-box-shadow: 0 1px 2px rgba(0,0,0,.05);
                box-shadow: 0 1px 2px rgba(0,0,0,.05);
      }
      .form-signin .form-signin-heading,
      .form-signin .checkbox {
        margin-bottom: 10px;
      }
      .form-signin input[type="text"],
      .form-signin input[type="password"] {
        font-size: 16px;
        height: auto;
        margin-bottom: 15px;
        padding: 7px 9px;
      }
      #logo
        {
            background:url(https://b85f3156fb2be67c6546-dc86b69d4fca8182524d9df6daa0bf43.ssl.cf2.rackcdn.com/logo_header_02.png) no-repeat center center;
            height:60px;
            width:200px;
            margin: 0 auto;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
                <div id="logo"> </div>
    <div class="row-fluid">

        <form id="logInForm" runat="server" class="form-signin">
        <fieldset>
            <legend>Log In</legend>
            
            <label for="DevCenterEmail">DevCenter E-mail</label>
            <asp:TextBox runat="server" id="DevCenterEmail" type="text" name="DevCenterEmail" Text="<%#email %>" class="span12" />

            <label for="DevCenterPassword">Password</label>
            <asp:TextBox runat="server" id="DevCenterPassword" type="password" name="DevCenterPassword" Text="<%#password %>" class="span12" />

            <label for="DevCenterIKey">Your Integrator Key</label>
            <input id="DevCenterIKey" type="text" name="DevCenterIKey" value="<%=key %>"  class="span12" />

                <div class="alert">
                     <span><b>Need a DevCenter Account?</b></span><br />
                            Get it <a href="http://www.docusign.com/developers-center/get-free-developer-account">
                                here</a>.
               </div>

            <div id="action" class="centeralign" style="width: 150px;">
                <button class="btn btn-primary" runat="server" onserverclick="On_Login">Login</button>
            </div>
        </fieldset>
        </form>
    </div>
</asp:Content>
