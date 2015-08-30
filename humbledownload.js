(function () {
  var size = gamekeys.length,
      output = '';

  gamekeys.forEach(function (key) {
    $.ajax({
      url: 'https://www.humblebundle.com/api/v1/order/' + key + '?all_tpkds=true',
      success: function(data) {
        data.subproducts.forEach(function (product) {
          product.downloads.forEach(function (download) {
           download.download_struct.forEach(function (struct) {
             if (struct.url) {
               output += product.human_name.trim().replace(/(\r\n|\n|\r|\/)/gm,"") + '<br>' + struct.url.web.split('?')[0].split('.net/')[1] + '<br>' + struct.url.web + '<br>';
             }
           });
          });
        });

        size--;

        if (size == 0) {
          $('body').empty().append(output);
        }
      },
      error: function () {
        alert('Failed to retrieve a link, try again!');
      }
    });
  })
})();
