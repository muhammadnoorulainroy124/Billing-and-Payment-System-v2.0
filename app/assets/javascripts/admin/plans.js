// # Place all the behaviors and hooks related to the matching controller here.
// # All this logic will automatically be available in application.js.
// # You can use CoffeeScript in this file: http://coffeescript.org/

 $(document).ready(function(){
  let counter=1;
  $('.add-feature').click(function(e){

    let html = `
    <div class="container">
    <div class="form-group row">
      <input class="form-control col-3 mr-auto" type="number" name="features[[feature_${counter}_code]]" placeholder="Feature Code"/>
      <input class="form-control col-3 mr-auto" type="number" name="features[[feature_${counter}_usage]]" placeholder="Usage"/>
      <input class="form-control col-3 " type="number" name="features[[feature_${counter}_limit]]" placeholder="Max Limit"/>
      <a href="#" class="remove_feature btn btn-danger">Remove</a>
    </div></div>`;
    e.preventDefault();
    $(".form-elements").append(html);
    counter++;
  });

  $('.form-elements').on('click', '.remove_feature', function(e){
    e.preventDefault();
    $(this).parent('div').remove();
    counter--;
  });
 });


