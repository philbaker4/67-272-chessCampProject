

  ////////////////////////////////////////////////
  //// Setting up a general ajax_2 method to handle
  //// transfer of data between client and server
  ////////////////////////////////////////////////
  function run_ajax_2(method, data, link, callback=function(res){instructors.get_instructors()}){
    $.ajax_2({
      method: method,
      data: data,
      url: link,
      success: function(res) {
        instructors.errors = {};
        callback(res);
      },
      error: function(res) {
        console.log("error");
        instructors.errors = res.responseJSON;
      }
    })
  } 



  /////////////////////////////////////////////
  //// A component for adding a new instructor
  /////////////////////////////////////////////
  var new_form = Vue.component('new-registration-form', {
    template: '#registration-form-template',

    mounted() {
      // need to reconnect the materialize select javascript 
      $('#registration_student_id').material_select()
    },

    data: function () {
      return {
          camp_id: 0,
          instructor_id: 0,
          errors: {}
      }
    },

    methods: {
      submitForm: function (x) {
        new_post = {
          camp_id: this.camp_id,
          instructor_id: this.instructor_id
        }
        run_ajax_2('POST', {student: new_post}, add_to_cart_path)
        this.switch_modal()
      }
    },
  })



  //////////////////////////////////////////
  ////***  The Vue instance itself  ***////
  /////////////////////////////////////////
  var registrations = new Vue({

    el: '#registrations',

    data: {
      camp_id: 0,
      modal_open: false,
      errors: {}
    },

    created() {
      this.camp_id = $('#camp_id').val();
    },
    

    methods: {
      switch_modal: function(event){
        this.modal_open = !(this.modal_open);
      },

    },

  });

