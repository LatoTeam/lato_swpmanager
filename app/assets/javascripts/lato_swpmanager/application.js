$(document).ready(function () {

  $('.lato-swpmanager-task-start-date-input').change(function() {
    $('.lato-swpmanager-task-end-date-input').val($(this).val())
    $( "input[name='task[end_date]']" ).val($(this).val())
  })

  $('.latoswpmanager-timeline-date-select-button').click(function() {
    $('.latoswpmanager-timeline-date-select').toggleClass('active')
  })

})
