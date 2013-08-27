<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultPage.Master" AutoEventWireup="true"
    CodeBehind="Error.aspx.cs" Inherits="DocuSignSample.Error" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        body
        {
            padding-top: 40px;
            padding-bottom: 40px;
            background-color: #f5f5f5;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="alert alert-error">
        <span><b>This demo has encountered an error:</b></span><br />
        <p>

            <asp:Label ID="lblErrorMessage" runat="server" Text=""></asp:Label>
        </p>
        <br />
        Please correct the issue and try again.
   
        <p>
            To get help, please visit the <a href="http://community.docusign.com">DocuSign Community
            Forums</a>.
        </p>
    </div>

</asp:Content>
