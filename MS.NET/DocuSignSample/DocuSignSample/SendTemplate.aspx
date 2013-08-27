<%@ Page Title="" Language="C#" MasterPageFile="~/Tabs.Master" AutoEventWireup="true"
    CodeBehind="SendTemplate.aspx.cs" Inherits="DocuSignSample.SendTemplate" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript" charset="utf-8">

        $(function () {
            var today = new Date();
            $("#reminders").datepicker({
                minDate: today
            });
            $("#expiration").datepicker({
                buttonImageOnly: true,
                minDate: today
            });

        });

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <form id="SendTemplateForm" action="SendTemplate.aspx" runat="server">
        <div class="row-fluid">
            <div class="span12">
                <asp:TextBox runat="server" id="txtSubject" placeholder="enter the subject" autocomplete="off" class="span12" />
            </div>
        </div>
        <div class="row-fluid">
            <div class="span12">
                <asp:TextBox runat="server" id="txtEmailBlurb" cols="20" placeholder="enter the e-mail blurb"
                    rows="4" class="span12" TextMode="MultiLine" />
            </div>
        </div>
        <hr />
        <div class="row-fluid">
            <div class="span12 form-horizontal">
                 <div class="control-group">
                    <label for="TemplateTable" class="control-label">Select a Template: </label>
                    <div class="controls">
                        <select id="Templates" name="Templates" runat="server"></select>
                        <button id="selectTemplateButton" runat="server" class="btn" onserverclick="OnTemplateSelect">Go</button>
                    </div>
                </div>
            </div>
        </div>
        <hr />
        <div class="row-fluid">
            <div class="span12">
                <table width="100%" id="RecipientTable" name="RecipientTable" runat="server" class="table">
                    <thead>
                    <tr class="rowheader">
                        <th class="fivecolumn">
                            <b>Role Name</b>
                        </th>
                        <th class="fivecolumn">
                            <b>Name</b>
                        </th>
                        <th class="fivecolumn">
                            <b>E-mail</b>
                        </th>
                        <th class="fivecolumn">
                            <b>Security</b>
                            <!--<img alt="" src="" class="helplink" />-->
                        </th>
                        <th class="fivecolumn">
                            <b>Send E-mail Invite</b>
                        </th>
                    </tr>
                        </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>

        <div class="row-fluid">
            <div class="span12 form-horizontal">
                <div class="control-group">
                    <label class="control-label" for="reminders">Add Daily Reminders: </label>
                    <div class="controls">

                        <div class="input-append">
                            <input type="text" id="reminders" class="datepickers" runat="server" />
                            <span class="add-on">
                                <label class="icon-calendar" for="reminders"></label>
                            </span>
                        </div>
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label" for="expiration">Add Expiration:</label>
                    <div class="controls">
                        <div class="input-append">
                            <input type="text" id="expiration" class="datepickers" runat="server" />
                            <span class="add-on">
                                <label class="icon-calendar" for="expiration"></label>
                            </span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="row-fluid">
            <div class="span6">
                <asp:Button runat="server" class="btn btn-large btn-success span8 pull-right" OnCommand="CreateEnvelope" CommandName="SendNow" Text="Send Now" />

            </div>
            <div class="span6">
                <asp:Button runat="server" class="btn btn-large btn-primary span8" OnCommand="CreateEnvelope"  CommandName="EmbedSending" Text="Edit Before Sending" />
            </div>
        </div>
    </form>
</asp:Content>
