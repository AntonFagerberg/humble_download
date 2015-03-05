var $r = null;
var $e = null;
var name = null;

var res = [];

$('.row').each(function (i, r) {
  $r = $(r);
  name = $r.attr('data-human-name').split('</br>').join('').split('<br>').join('').split('<br/>').join('').trim().replace(/(\r\n|\n|\r)/gm,"").split("/").join("");
  
  $r.find('a.a').each(function (i, e) {
    $e = $(e);
    res.push(name + '<br>' + $e.attr('href').split('?')[0].split('/')[3] + '<br>' + $e.attr('href') + '<br>');
  });
});

$b = $('body');
$b.empty();

$(res).each(function (i, r) {
  $b.append(r);
});