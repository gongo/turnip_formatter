$(function() {
    $('#statistics ul li a').click(function (e) {
        e.preventDefault()
        $(this).tab('show')
    })

    $('#speed-statistics a').click(function(e) {
        $('#statistics a[href="#steps-statistics"]').tab('show');
    });

    $('#scenario_display_check').change(function() {
        var action = $(this).prop("checked") ? 'show' : 'hide';
        $('.panel-collapse').collapse(action);
    });

    ["passed", "failed", "pending"].forEach(function(status) {
        $('#' + status + '_check').click(function() {
            if (this.checked) {
                $('.scenario.' + status).show();
            } else {
                $('.scenario.' + status).hide();
            }
        });
    });

    $(".scenario.passed").hide();
    $(".scenario.pending").hide();

    $("div#speed-statistics table").tablesorter({
        headers: {
            1: { sorter: false }
        }
    });
});
