// ~ views/search/do ~
define([
  'jquery',
  'underscore',
  'backbone',
  'collections/results',
  'text!templates/search/do.html',
  'datatables',
  'datatablessort',
  'helpers',
  'bootstrap',
  'datatablesbs'
], function($, _, Backbone, resultsCollection, doSearchTemplate){
  var doSearchView = Backbone.View.extend({
    el: "#content",
    initialize: function() {
      this.collection = new resultsCollection;
    },
    render: function(query){
      document.title = "Relay Search";
      var compiledTemplate = _.template(doSearchTemplate);
      var relays = this.relays;
      this.$el.html(compiledTemplate({query: query,
                                     relays: relays,
                                     countries: CountryCodes,
                                     error: this.error,
                                     onionooVersion: this.onionooVersion,
                                     buildRevision: this.buildRevision,
                                     relaysPublished: this.relaysPublished,
                                     bridgesPublished: this.bridgesPublished}));

      // This creates the table using DataTables
      loadSortingExtensions();
      var oTable = $('#torstatus_results').dataTable({
        //Define column specific options
        "aoColumns": [
                      null,   //Status
                      null,   //Nickname
                      { "sType":  "file-size" },  //Bandwidth
                      null,   //Uptime
                      null,   //Country
                      { "sType":  "ip-address" },  //IP Address
                      { "sType":  "ip-address" },   //IPv6 Address
                      null,   //Flags
                      null,   //Additional Flags
                      null,   //ORPort
                      null,   //DirPort
                      null    //Type
                  ],
        "sDom": "<\"top\"l>rt<\"bottom\"ip><\"clear\">",
        "bStateSave": false,
        "aaSorting": [[2, "desc"]],
        "fnDrawCallback": function( oSettings ) {
          $(".tip").tooltip({'html':true});
        },
        "footerCallback": function( tfoot, data, start, end, display ) {
          var sumAdvertisedBandwidths = 0;
          for (var i = 0; i < relays.length; i++) {
            sumAdvertisedBandwidths += relays[i].get("advertised_bandwidth");
          }
          $(tfoot).find('th').eq(2).html(hrBandwidth(sumAdvertisedBandwidths));
        }
      });
    },
    renderError: function(){
      var compiledTemplate = _.template(doSearchTemplate);
      this.$el.html(compiledTemplate({relays: null, error: this.error, countries: null}));
    }
  });
  return new doSearchView;
});

