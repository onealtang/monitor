<input id="ss" class="easyui-searchbox" style="width:300px"
       data-options="searcher:qq,prompt:'Please Input value',menu:'#mm'"></input>

<div id="mm" style="width:120px">
    <div data-options="name:'guid'">idfa/adid</div>
    <div data-options="name:'offerId'">offerId</div>
</div>

<div id="result">

</div>

<script type="text/javascript">

    function qq(value, name) {

        if (name == "guid") {
            $.ajax({
                url: 'Install/CheckDeviceState',
                type: 'POST',
                data: {
                    guid: value
                },
                success: function (data) {
                    $("#result").text(JSON.stringify(data))
                }
            })
        } else {
            $.ajax({
                url: 'Adunit/QueryAdunit',
                type: 'POST',
                data: {
                    offerId: value
                },
                success: function (data) {
                    $("#result").text(JSON.stringify(data))
                }
            })
        }
    }

    $(function () {
    });
</script>