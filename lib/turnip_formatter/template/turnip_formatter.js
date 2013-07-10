$(function() {
    var scenarioHeader = 'section.scenario header';
    $(scenarioHeader).siblings().hide();

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

    /**
     * Tabs
     */
    $('div#main').tabs();
    $('div#speed-statistics a').click(function() {
        $('div#main').tabs("option", "active", 0);
    });

    $("div#speed-statistics table").tablesorter({
        headers: {
            1: { sorter: false }
        }
    });
});
