function read (ids) {
  $.ajax({
      url:     '/posts/' + ids,
      type:    'DELETE',
      success: function(result) {
        location.reload(true);
      },
      error:   function(xhr, desc, err) {
        alert("Read request failed: " + desc + ", " + err);
      }
  });
}
