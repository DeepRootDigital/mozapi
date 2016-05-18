var ready = function() {
  $('#submit-btn').click(function(){
    window.location.href = "http://localhost:3000/show" + "?url=" + $('#website-url').val();
  });
}

$(document).on('ready page:load', ready);