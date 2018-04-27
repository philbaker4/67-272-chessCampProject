Vue.component('tab', {

  template: `
    <div v-show="isActive" ><slot></slot></div>
  `,

  props: {
    name: { required: true },
    selected: { default: false }

  },

  data() {
    return {
      isActive: false
    };

  },

  computed: {
    href() {
      return "#" + this.name.toLowerCase().replace(/ /g, '-');            
    }

  },

  mounted() {
    this.isActive = this.selected;

  } 

});

Vue.component('tabs', {
  template: `
  <div class="row">

    <div class="col s12">
      <ul class="tabs">
        <a href="#test1">Test 1</a>
        <li class="tab col s3" v-for="tab in tabs"><a v-bind:href="tab.href" v-bind:class="{ 'active': tab.isActive }" v-on:click="selectTab(tab)">{{ tab.name }}</a></li>
        <a class="active" href="#test2">Disabled Tab</a>
        <a href="#test4">Test 4</a>
      </ul>
    </div>
    <div id="test1" class="col s12">Test 1</div>
    <div class="tab-details"><slot></slot></div>
    <div id="test3" class="col s12">Test 3</div>
    <div id="test4" class="col s12">Test 4</div>


  </div>

  `,

  data() {
    return { tabs: [] };

  },

  created() {
    this.tabs = this.$children;

  },

  methods: {
    selectTab(selectedTab) {
  this.tabs.forEach(tab => {
    tab.isActive = (tab.name == selectedTab.name)
  });
}

  }

});

var vm = new Vue({
  el: '#index' 
});