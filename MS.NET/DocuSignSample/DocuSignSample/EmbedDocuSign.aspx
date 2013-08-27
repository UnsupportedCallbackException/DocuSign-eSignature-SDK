<%@ Page Title="" Language="C#" MasterPageFile="~/Tabs.Master" AutoEventWireup="true"
    CodeBehind="EmbedDocuSign.aspx.cs" Inherits="DocuSignSample.EmbedDocuSign" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server" />

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <form runat="server" id="EmbedDocuSignForm" action="EmbedDocuSign.aspx">
    
    <div class="row-fluid" id="buttonTable" runat="server">
                <div class="span6">
                    <button id="OneSigner" type="submit" class="btn btn-large btn-success span10 pull-right">Create an Envelope with 1 Signer</button>

                </div>
                <div class="span6">
                    <button id="TwoSigners" type="submit"
                        class="btn btn-large btn-primary span10">Create an Envelope with 2 Signers</button>
                </div>
            </div>
    </form>
    
    <div class="signerMessage" id="messagediv" name="messagediv" runat="server" visible="false"><%=signerMessage %></div>
    
    <iframe width="100%" height="750" src="" id="hostiframe" name="hostiframe" runat="server"></iframe>
</asp:Content>
