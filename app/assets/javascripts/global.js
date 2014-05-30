$(function () {
  register_datepickers();
  register_journal_controls();
  register_mentor_journal_date_selectors();
  register_schedule_checkboxes();
  register_todotogglers();
  register_kidsfilter();
  register_documents_toc();
  register_affixes();
  register_kidanchors();
});

// affix navigation
// nav gets affixed when scrolling
// nav-wrapper stays on normal flow to assure smooth scrolling
function register_affixes() {
  $('#nav').affix({
      offset: { top: $('#nav').offset().top }
  });
  $('#nav-wrapper').height($("#nav").height());
  $('#sidebar').affix({
      offset: { top: $('#nav').offset().top }
  });
  $('#sidebar').css('width', $('#sidebar').width());
}

// registers jquery ui datepickers on given fields when applicable
function register_datepickers() {

  var date_settings = {
    usa: false,
    separator: '.',
  };

  var time_settings = {
    isoTime: true,
    separator: '.',
    minTime: {hour: 13, minute: 0},
    maxTime: {hour: 20, minute: 30},
    timeInterval: 15
  };

  $('input.calendricalDate').calendricalDate(date_settings);
  $('#journal_start_at, #journal_end_at').calendricalTimeRange(time_settings)
  $('#kid_meeting_start_at').calendricalTime(time_settings);

}

// register active features on the journal entry form
function register_journal_controls() {
  $('#journal_cancelled').change(function() {
    var show_times = !($(this).is(':checked'));
    $('#journal_start_at_input, #journal_end_at_input').toggle(show_times);
  });
  $('#journal_cancelled').change();
}

// on the mentors page, two selectors allow choosing a filter data for journal
function register_mentor_journal_date_selectors() {
  $('select.select_mentor_journal_date').change(function() {
    var href =  window.location.pathname;
    href += '?month='+$('#date_month').val();
    href += '&year='+$('#date_year').val();
    href += '#mentor_journal_date';
    window.location = href;
  });
}

function register_schedule_checkboxes() {
  $('table.schedule input[type=checkbox]').change(function(){
    $(this).siblings('input').toggleEnabled(this.checked) });
  $('table.schedule input[type=checkbox]').each(function(){
    $(this).siblings('input').toggleEnabled(this.checked) });
}

function register_todotogglers() {
  $('a.todotoggle').popover({ placement: 'left', html: true });
}

function register_kidsfilter() {
  $('form.filter select, form.filter input').change(function(event) {
    $('form.filter').submit();
  });
}
function register_documents_toc() {
  $('#documents .panel-heading').click(function(event) {
    $header = $(this);
    $list = $header.next('.list-group');
    $header.toggleClass('open');
    $list.toggleClass('open');
  });
}

function register_kidanchors() {
  $('#sidebar .kidanchors a').click(function(event) {
    event.preventDefault();

    var target = this.hash,
	  $target = $(target);

	  $('html, body').stop().animate({
	    'scrollTop': $target.offset().top - $('#nav').height()
	  }, 500, 'swing');
  });
}
