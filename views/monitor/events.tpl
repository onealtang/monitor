<div class="query">
    <div style="margin:10px 0">
        <span>conversion id: </span>
                <span>
                    <input class="easyui-textbox" data-options="prompt:'Conversion ID'" id="event_cvid"
                           style="width: 300px;height:24px">
                </span>
        <span>guid: </span>
                <span>
                    <input class="easyui-textbox" data-options="prompt:'guid'" id="event_guid"
                           style="width: 280px;height:24px">
                </span>
    </div>
    <div style="margin-bottom:10px">
                <span>
                    <input class="easyui-datetimebox" id="event_startDate" style="width:150px;height: 24px">
                </span>
                <span>
                    <input class="easyui-datetimebox" id="event_endDate" style="width:150px;height: 24px">
                </span>
                <span>
                    <a id="event_btn" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a>
                </span>
    </div>
</div>
<div class="grid-result">
    <table id="event_dg" style="height: 600px;"
           data-options="
                    rownumbers:true,
                    singleSelect:true,
                    autoRowHeight:false,
                    pagination:true,
                    pageSize:20">
        <thead>
        <th field="CreateDate" width="120">CreateDate</th>
        <th field="UtcDate" width="120">UtcDate</th>
        <th field="ConversionId" width="120">ConversionId</th>
        <th field="SessionId" width="200">SessionId</th>
        <th field="Guid" width="240">Guid</th>
        <th field="Action" width="120">Action</th>
        <th field="Label" width="120">Label</th>
        <th field="Value" width="120">Value</th>
        </thead>
    </table>
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

        $('#event_dg').datagrid({data: null}).datagrid('clientPaging');

        $('#event_btn').bind('click', function () {

            $.ajax({
                url: 'Tracking/QueryEvent',
                type: 'POST',
                data: {
                    conversionId: $('#event_cvid').val(),
                    guid: $('#event_guid').val(),
                    startDate: $('#event_startDate').datetimebox('getValue'),
                    endDate: $('#event_endDate').datetimebox('getValue')
                },
                success: function (data) {
                    if (data.rows) {
                        $('#event_dg').datagrid('loadData', data);
                    } else {
                        $('#event_dg').datagrid({data: {total: 0, rows: {}}});
                    }
                }
            })

        });
    }

    $(function () {
        renderEvent();
    });
</script>