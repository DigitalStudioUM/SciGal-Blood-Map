function toggle_menu() {
    $("#menu").fadeToggle("fast");
    $("#menu_background").fadeToggle("fast");
    $("#menu-container").fadeToggle("fast");
    $("#general").show();
    $(".menu_tab").removeClass("active");
    $(".menu_tab").first().addClass("active");
    $(".menu_button").fadeToggle("fast");
    $(".blood_button").fadeToggle("fast");
    
}

function open_tab(trigger, tabName) {
    $(".menu_content").hide();
    $(".menu_tab").removeClass("active");
    $(tabName).show();
    $(trigger.currentTarget).addClass("active");
}

function toggle_blood(){
    bloodMarkersShowing = !bloodMarkersShowing;
    updateBloodMarkers();
}