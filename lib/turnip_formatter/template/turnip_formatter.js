$(function() {
    var scenarioHeader = 'section.scenario header';
    $(scenarioHeader).siblings().hide();

    $('#statistics ul li a').click(function (e) {
        e.preventDefault()
        $(this).tab('show')
    })

    $('#speed-statistics a').click(function(e) {
        $('#statistics a[href="#steps-statistics"]').tab('show');
    });

    /**
     * Step folding/expanding
     */
    $(scenarioHeader).click(function() {
        $(this).siblings().slideToggle();
    });

    /**
     * All step folding/expanding action
     */
    $('#scenario_display_check').change(function() {
        var steps = $(scenarioHeader).siblings();

        if (this.checked) {
            steps.slideUp();
        } else {
            steps.slideDown();
        }
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
