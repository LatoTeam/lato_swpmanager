$(document).ready(function () {

  $('#latoswpmanager-project-tasks-new-button').click(function () {
    $('.latoswpmanager-project-tasks-form').toggleClass('active')
  })

  $('.lato-swpmanager-task-start-date-input').change(function() {
    $('.lato-swpmanager-task-end-date-input').val($(this).val())
    $( "input[name='task[end_date]']" ).val($(this).val())
  })

})
