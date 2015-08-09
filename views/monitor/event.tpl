<div title="Tracking event" style="">
    <div class="query">
                <span>
                    <input class="easyui-textbox" data-options="prompt:'Conversion ID'" id="event_cvid" style="width: 150px;height:32px">
                </span>
                <span>
                    <input class="easyui-datetimebox" id="event_startDate" style="width:150px">
                </span>
                <span>
                    <input class="easyui-datetimebox" id="event_endDate" style="width:150px">
                </span>
                <span>
                    <a id="event_btn" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a>
                </span>
    </div>
    <div class="grid-result">
        <table id="event_dg" style="height: 400px;"
               data-options="
                    rownumbers:true,
                    singleSelect:true,
                    autoRowHeight:false,
                    pagination:true,
                    pageSize:20">
        </table>
    </div>
</div>

<script type="text/javascript">

    function renderEvent() {

        var now = new Date()
        $('#event_startDate').datetimebox({
            value: new Date(now.getTime() - 7 * 24 * 60 * 60 * 1000).format()
        });
        $('#event_endDate').datetimebox({
            value: now.format()
        });

        $('#event_btn').bind('click', function () {

            $.ajax({
                url: 'Tracking/QueryEvent',
                type: 'POST',
                data: {
                    conversionId: $('#event_cvid').val(),
                    startDate: $('#event_startDate').datetimebox('getValue'),
                    endDate: $('#event_endDate').datetimebox('getValue'),
                },
                success: function (data) {
                    if (data.rows) {
                        $('#event_dg').datagrid('loadData', data).datagrid('clientPaging');
                    } else {
                        $('#event_dg').datagrid('loadData', {total: 0, rows: {}});
                    }
                }
            })

        });

        $('#event_dg').datagrid({
            columns: [[
                {field: 'CreateDate', title: 'CreateDate', width: 120},
                {field: 'UtcDate', title: 'UtcDate', width: 120},
                {field: 'ConversionId', title: 'ConversionId', width: 120},
                {field: 'SessionId', title: 'SessionId', width: 120},
                {field: 'Guid', title: 'Guid', width: 120},
                {field: 'Action', title: 'Action', width: 120, align: 'right'},
                {field: 'Label', title: 'Label', width: 120, align: 'right'},
                {field: 'Value', title: 'Value', width: 120, align: 'right'}
            ]]
        }).datagrid('clientPaging');

    }

    $(function () {
        renderEvent();
    });

</script>
