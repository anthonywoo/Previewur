$(function(){
  $(".search-filter").on("click", function(event){
    event.stopPropagation();
    $('.time-search-options').addClass("hidden");
    $(".search-options").toggleClass("hidden");
  });

  $("body").on("click", function(){
    $('.time-search-options').addClass("hidden");
    $('.search-options').addClass("hidden");
  });

  $(".search-time").on("click", function(event){
    event.stopPropagation();
    $('.search-options').addClass("hidden");
    $(".time-search-options").toggleClass("hidden");
  });

  $(".search-option").on("click", function(event){
    $(".search-filter").attr("data-type", $(this).attr("data-type"));
    event.stopPropagation();
    var that = this;
    var dataQuery = {search: {cat: $(".search-filter").attr("data-type"), time: $(".search-time").attr("data-type")}};
    var url = "#" + dataQuery.search.cat + dataQuery.search.time
    history.pushState(dataQuery, "", url)
    $.ajax({
      url: "/images.js",
      data: dataQuery,
      success: function(){
        update_search_title(dataQuery);
      }
    });
  })

  $(window).bind('popstate', function(event) {
    var dataQuery = event.originalEvent.state;
    if (dataQuery){
      console.log(dataQuery)
      var url = "#" + dataQuery.search.cat + dataQuery.search.time
      history.pushState(dataQuery, "", url)
      $.ajax({
        url: "/images.js",
        data: dataQuery, 
        success: function(){
          update_search_title(dataQuery);
        }
      })
    }
  })

  var update_search_title = function(dataQuery){
    var cat_text = $("div").find("[data-type='" + dataQuery.search.cat + "']").filter("div").text();
    var time_text = $("div").find("[data-type='" + dataQuery.search.time + "']").filter("div").text();
    $(".search-time").html("");
    $(".search-time").html(time_text);
    $(".search-filter").html("");
    $(".search-filter").html(cat_text);
    $(".time-search-options").addClass("hidden");
    $(".search-options").addClass("hidden");
    $(".search-time").attr("data-type", dataQuery.search.time)
    $(".search-filter").attr("data-type", dataQuery.search.cat)
  };

  $(".time-search-option").on("click", function(event){
    $(".search-time").attr("data-type", $(this).attr("data-type"));
    event.stopPropagation();
    var that = this;
    var dataQuery = {search: {cat: $(".search-filter").attr("data-type"), time: $(".search-time").attr("data-type")}};
    var url = "#" + dataQuery.search.cat + dataQuery.search.time
    history.pushState(dataQuery, "", url)
    $.ajax({
      url: "/images.js",
      data: dataQuery, 
      success: function(){
        update_search_title(dataQuery)
      }
    });
  });
});