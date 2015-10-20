(function () {
  var size = gamekeys.length,
      output = [];

  gamekeys.forEach(function (key) {
    $.ajax({
      url: 'https://www.humblebundle.com/api/v1/order/' + key + '?all_tpkds=true',
      success: function(data) {
        output = output.concat(data.subproducts);

        size--;

        if (size == 0) {
          $('body').empty().append(JSON.stringify(output));
        }
      },
      error: function () {
        alert('Failed to retrieve a link, try again!');
      }
    });
  })
})();
