<link rel="import" href="../../bower_components/polymer/polymer.html">
<link rel="import" href="../../bower_components/px-card/px-card.html">
<link rel="import" href="../../bower_components/iron-ajax/iron-ajax.html">
<link rel="import" href="../../bower_components/px-data-table/px-data-table.html" />

<dom-module id="simple-asset-view">
  <template>

    <px-card header-text="Asset Details" icon="fa-sitemap">
      <h3>{{assetDescription}}</h3>
      <px-data-table table-data="{{assetTableData}}">
      </px-data-table>
      <!-- Choose one of these iron-ajax elements to load data from the source of your choice. -->

      <!-- First option loads sample data from a json file in the server/sample-data directory. -->
      <!-- mock-asset-service -->
      <iron-ajax url="/api/predix-asset/compressor-2017" id="assetQueryElement" last-response="{{rawAssetData}}" auto></iron-ajax>
      <!-- end mock-asset-service -->

      <!-- Second option loads compressor data from Predix Time Series directly. -->
      <!-- real-asset-service
      <iron-ajax url="/predix-api/predix-asset/asset/compressor-2017" id="assetQueryElement" last-response="{{rawAssetData}}" auto></iron-ajax>
      end real-asset-service -->

      <!-- Third option loads jet engine data from Predix Time Series directly. -->
      <!-- <iron-ajax url="/predix-api/predix-asset/engine" id="assetQueryElement" last-response="{{rawAssetData}}" auto></iron-ajax> -->

    </px-card>
  </template>
  <script>
    Polymer({
      is: 'simple-asset-view',
      properties: {
        tsChartData: {
          type: Array
        },
        rawAssetData: {
          type: Object,
          observer: '_formatDataForTable'
        },
        assetTableData: {
          type: Object
        },
        assetDescription: {
          type: String
        }
      },

      _formatDataForTable: function(raw) {
        if (raw[0].assetTag) {
          this._formatAssetTagsForTable(raw);
        } else {
          this._formatEngineDataForTable(raw);
        }
      },

      _formatAssetTagsForTable: function(raw) {
        var sensor, sensors = [];
        var assetTags = raw[0].assetTag;
        for (var property in assetTags) {
          if (assetTags.hasOwnProperty(property)) {
            sensor = assetTags[property];
            delete sensor.complexType;
            delete sensor.tagDatasource;
            sensors.push(sensor);
          }
        }
        this.assetTableData = sensors;
        this.assetDescription = raw[0].description + ": " + raw[0].assetId;
      },

      _formatEngineDataForTable: function(raw) {
        raw.forEach(function(engine) {
          engine.partUri = engine.jetEnginePart.uri;
          engine.partSerialNo = engine.jetEnginePart.sNo;
          delete engine.jetEnginePart;
        })
        this.assetTableData = raw;
        this.assetDescription = "Jet Engines";
      }
    });
  </script>
</dom-module>
