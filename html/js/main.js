$(function() {
   $('.sale').delay(3).fadeIn();
});

function goBack()
{
    parent.history.back();
    return false;
}
//function why() {
//    $(this).on('click', function(e){
//        e.preventDefault();
//        $('.why_info').css({display:'block'});
//    });
//}
//function close_why() {
//    $(this).on('click', function(){
//        $('.why_info').css({display:'none'})
//    });
//}