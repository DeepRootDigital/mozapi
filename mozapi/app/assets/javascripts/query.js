var ready = function() {
  $('#submit-btn').click(function(){
    window.location.href = "http://104.236.156.31//show" + "?url=" + $('#website-url').val();
  });
}

$(document).on('ready page:load', ready);