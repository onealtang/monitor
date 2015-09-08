<div class="query">
    <label>Flight: </label>
                <span>
                    <input class="easyui-combobox" id="s2s_adunitList" name="s2s_adunitId" type="text"
                           data-options="valueField:'campaignId',textField:'campaignName',prompt:'请选择广告单元'">
                </span>
    <label>conversion id: </label>
                <span>
                    <input class="easyui-textbox" data-options="prompt:'Conversion ID'" id="event_cvid"
                           style="width: 300px;height:32px">
                </span>
                <label>idfa/adid: </label>
                <span>
                    <input class="easyui-textbox" data-options="prompt:'guid'" id="event_guid"
                           style="width: 280px;height:32px">
                </span>

    <div>
                <span>
                    <input class="easyui-datetimebox" id="s2s_startDate" style="width:150px;height: 32px">
                </span>
                <span>
                    <input class="easyui-datetimebox" id="s2s_endDate" style="width:150px; height: 32px">
                </span>
                <span>
                    <a id="s2s_btn" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a>
                </span>
    </div>

</div>
<div class="grid-result">
    <table id="s2s_dg" style="height: 600px;" data-options="
                rownumbers:true,
                singleSelect:true,
                autoRowHeight:false,
                pagination:true,
                pageSize:20"></table>
</div>

<script type="text/javascript">

    function renderS2sLog() {

        var now = new Date()
        $('#s2s_startDate').datetimebox({
            value: new Date(now.getTime() - 7 * 24 * 60 * 60 * 1000).format()
        });
        $('#s2s_endDate').datetimebox({
            value: now.format()
        });

        $('#s2s_adunitList').combobox({
            url: 'Adunit/GetAll',
            valueField: 'campaignId',
            textField: 'campaignName'
        });

        $('#s2s_dg').datagrid({
            columns: [[
                {field: 'OfferId', title: 'Offer id', width: 120, align: 'left'},
                {field: 'CreatedDate', title: 'Created Date', width: 120},
                {field: 'ConversionId', title: 'Conversion Id', width: 120},
                {field: 'Guid', title: 'Guid', width: 240},
                {field: 'Url', title: 'URL', width: 1000},
            ]]
        }).datagrid('clientPaging');

        $('#s2s_btn').bind('click', function () {

            $.ajax({
                url: 'S2sActiveLog/SearchS2sLog',
                type: 'POST',
                data: {
                    startDate: $('#s2s_startDate').datetimebox('getValue'),
                    endDate: $('#s2s_endDate').datetimebox('getValue'),
                    campaignId: $("input[name='s2s_adunitId']").val(),
                    conversionId: $('#event_cvid').val(),
                    guid: $('#event_guid').val()
                },
                success: function (data) {
                    if (data.rows) {
                        $('#s2s_dg').datagrid('loadData', data);
                    } else {
                        $('#s2s_dg').datagrid('loadData', {total: 0, rows: {}});
                    }
                }
            })


        });

    }
    $(function () {
        renderS2sLog();
    });
</script>