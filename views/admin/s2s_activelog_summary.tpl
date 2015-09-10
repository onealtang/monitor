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
    <table id="dg" style="height: 600px;" data-options="
                rownumbers:true,
                singleSelect:true,
                autoRowHeight:false,
                pagination:true,
                pageSize:20"></table>
</div>

<script type="text/javascript">

    function renderSummary() {
        $('#adunitList').combobox({
            url: 'Adunit/GetAll',
            valueField: 'campaignId',
            textField: 'campaignName'
        });

        var now = new Date()
        $('#startDate').datetimebox({
            value: new Date(now.getTime() - 7 * 24 * 60 * 60 * 1000).format()
        });
        $('#endDate').datetimebox({
            value: now.format()
        });

        $('#btn').bind('click', function () {
            $('#dg').datagrid('load', {
                startDate: $('#startDate').datetimebox('getValue'),
                endDate: $('#endDate').datetimebox('getValue'),
                campaignId: $("input[name='adunitId']").val()

            });
        });

        $('#dg').datagrid({
            url: 'Adunit/QueryCampaign',
            columns: [[
                {field: 'CampaignId', title: 'Offer ID', width: 300},
                {field: 'CampaignName', title: 'Campaign Name', width: 300},
                {field: 'ReceivedCount', title: 'Received Installs', width: 120, align: 'right'},
                {field: 'PostbackCount', title: 'Postback Installs', width: 120, align: 'right'}
            ]]
        }).datagrid('clientPaging');

    }

    (function($){
        renderSummary();
    });
</script>