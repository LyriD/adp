$(function() {

    $('.current_taxon').parent().css('display', 'block');
    $('.current_taxon').css('margin-left', '20px');
    $('.active_taxon').next('.taxons-list').slideToggle();
   $('.sale').delay(3).fadeIn();

    $('li.head').on('click', function(){
        $('.taxons-list').slideUp();
        $(this).next('.taxons-list').slideToggle();
    })
});

$(document).ready(function(){
    $('a.back').click(function(){
        if(document.referrer.indexOf(window.location.hostname) != -1){
            parent.history.back();
            return false;
        }
    });


});