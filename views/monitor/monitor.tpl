<body>
    <div>
        <span>
            <input class="easyui-combobox" id="adunitList" name="adunitId"
                   data-options="valueField:'campaignId',textField:'campaignName'">
        </span>
        <span>
            <input class="easyui-datetimebox" id="startDate" style="width:150px">
        </span>
        <span>
            <input class="easyui-datetimebox" id="endDate" style="width:150px">
        </span>
        <span>
            <a id="btn" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a>
        </span>

    </div>
    <div>
        <table id="dg"></table>
    </div>
</body>
<script type="text/javascript">
    $(function () {
        $('#adunitList').combobox({
            url: 'Adunit/GetAll',
            valueField: 'campaignId',
            textField: 'campaignName'
        });

        $('#btn').bind('click', function () {
            $('#dg').datagrid('load', {
                startDate: $('#startDate').datetimebox('getValue'),
                endDate: $('#endDate').datetimebox('getValue'),
                campaignId: $("input[name='adunitId']").val()

            })
        });

        var now = new Date()
        $('#startDate').datetimebox({
            value: new Date(now.getTime() - 7 * 24 * 60 * 60 * 1000).format()
        });
        $('#endDate').datetimebox({
            value: now.format()
        });

        $('#dg').datagrid({
            url:'Adunit/QueryCampaign',
            columns: [[
                {field: 'campaignId', title: 'Offer ID', width: 300},
                {field: 'campaignName', title: 'Campaign Name', width: 300},
                {field: 'receivedCount', title: 'Received Installs', width: 120, align: 'right'},
                {field: 'postbackCount', title: 'Postback Installs', width: 120, align: 'right'}
            ]]
        });
    })
</script>