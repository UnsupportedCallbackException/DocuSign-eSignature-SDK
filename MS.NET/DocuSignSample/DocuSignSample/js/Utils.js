function addRowToTable() {
    var tbl = document.getElementById('recipientList');
    var lastRow = tbl.rows.length;
    // if there's no header row in the table, then iteration = lastRow + 1
    var iteration = lastRow;
    var row = tbl.insertRow(lastRow);

    var rowHtlm = [
            '<td>',
	            '<input type="text" name="RecipientName###"/>',
            '</td>',
            '<td>',
	            '<input type="email" name="RecipientEmail###"/>',
            '</td>',
            '<td>',
	            '<select id="RecipientSecurity###" name="RecipientSecurity###" onchange="EnableDisableInput(###)">',
		            '<option value="None">None</option>',
		            '<option value="AccessCode">Access Code:</option>',
		            '<option value="PhoneAuthentication">Phone Authentication</option>',
		            '<option value="IDCheck">ID Check</option>',
	            '</select> ',
	            '<input id="RecipientSecuritySetting###" type="text" name="RecipientSecuritySetting###" style="display: none; width:100px;"/>',
            '</td>',
            '<td>',
	            '<div class="btn-group" data-toggle="buttons-radio">',
		            '<button type="button" class="btn active">ON</button>',
		            '<button type="button" class="btn">OFF</button>',
	            '</div>',
	            '<input id="RecipientInviteToggle###" name="RecipientInviteToggle###" value="RecipientInviteToggle###" type="checkbox" checked style="visibility:hidden;"/>',
            '</td>'
    ];
    rowHtlm = rowHtlm.join('').replace(/###/ig, iteration);
    row.innerHTML = rowHtlm;

    activate();
}


function dialogOpen() {
    $("#dialogmodal").dialog({
        height: 350,
        width: 600,
        modal: true
    });
}

function dialogClose() {
    $("#dialogmodal").dialog('close');
}

function toggle(id) {
    $('#' + id).toggle();    
}

function EnableDisableDiv() {
    if ($("#sendoption").is(':checked')) {
        $("#files").hide(200).disableSelection();
    } else {
        $("#files").show(200).enableSelection();
    }
}

function EnableDisableInput(id) {
    var
        $elem = $('#RecipientSecuritySetting' + id),
        $select = $("#RecipientSecurity" + id);

    if ($select[0].selectedIndex == 1) {
        $elem.show().enableSelection();
    }
    else {
        $elem.hide().disableSelection();
    }
}


$(function () {
    $('#recipientList').on('click', '.btn-group button', function () {
        var
            $btn = $(this),
            $chbox = $btn.closest('td').find(':checkbox');

        $chbox.prop('checked', $btn.text() === 'ON' );
    });
});