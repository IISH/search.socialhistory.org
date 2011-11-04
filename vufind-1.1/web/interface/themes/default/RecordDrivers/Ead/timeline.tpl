{literal}
<link rel="stylesheet" type="text/css" href="../interface/themes/default/css/iish.timeline.css"/>
<script type="text/javascript">
    // Set the absolute path to your simile-api directory
    var apiPath = '{/literal}{$url}{literal}/js/simile-api';

    // Load Exhibit & Extention items as required
    load(apiPath + '/exhibit/latest/exhibit-api.js');
    load(apiPath + '/exhibit/latest/extensions/time/time-extension.js');
    // load( apiPath + '/exhibit/latest/extensions/timeplot/timeplot-extension.js' );
    // load( apiPath + '/exhibit/latest/extensions/map/map-extension.js?gmapkey=' );
    // load( apiPath + '/exhibit/latest/extensions/map/map-extension.js?service=openlayers' );
    // load( apiPath + '/exhibit/latest/extensions/chart/chart-extension.js' );
    // load( apiPath + '/exhibit/latest/extensions/calendar/calendar-extension.js' );

    //load( apiPath + '/timeline/2.3.1/timeline-api.js' );
    // load( apiPath + '/timeplot/1.1/timeplot-api.js' );
    // load( apiPath + '/timegrid/timegrid-api.js' );
    // load( apiPath + '/runway/1.0/runway-api.js' );


    function load(url) {
    var script = '<script type="text/javascript" src="'+ url +'"></scr'+'ipt>\n';
    document.write( script );
    }
</script>
<script type="text/javascript">
    <!--
    var timelineConfig = {
    timelineConstructor: function (div, eventSource) {
                // hoogte van timeline
    div.style.height = "980px";

    var theme = Timeline.ClassicTheme.create();
    theme.event.label.width = 200;
    theme.event.bubble.width = 400;
    theme.event.bubble.height = 400;

    // centreer welke datum
    var date = "Jan 1 1875 00:00:00 GMT-0000";

    // creeer de timeline banden
    var bandInfos = [

    Timeline.createBandInfo({
    width:                "9%"
    , intervalUnit:        Timeline.DateTime.YEAR
    , intervalPixels:    35
    , date:                date
    , theme:            theme
    , eventSource:        eventSource
    , showEventText:    false
    , trackHeight:        0.5
    , trackGap:            0.2
    , overview:            true
    })
    ,
    Timeline.createBandInfo({
    width:                "91%"
    , intervalUnit:        Timeline.DateTime.YEAR
    , intervalPixels:    150
    , eventSource:        eventSource
    , date:                date
    , theme:            theme
    })

    ];
    bandInfos[1].syncWith = 0;
    bandInfos[1].highlight = true;

    tl = Timeline.create(div, bandInfos, Timeline.HORIZONTAL);
    return tl;
    }
    }
    // -->
</script>
{/literal}
<div ex:role="collection" ex:itemTypes="Item"></div>
<table id="frame" width="100%" cellspacing="14">
    <tr>
        <td id="menu" width="9%"></td>
        <td id="content">
            <div ex:role="viewPanel">
                <!-- Google and Timeline popup -->
                <div class="map-lens" ex:role="lens" style="display: none;">
                    <div><img ex:src-content=".image" align="right"/><span ex:content=".name" class="name"></span><br/>
                    </div>
                    <div>Size: <span ex:content=".size" class="size"></span></div>
                    <div>Period: <span ex:content=".from" class="year"></span>&nbsp;-&nbsp;<span ex:content=".to"
                                                                                                 class="year"></span>
                    </div>

                    <div>Country: <span ex:content=".country" class="country"></span></div>
                    <div>Language: <span ex:content=".language" class="language"></span></div>
                    <div><a ex:href-content=".finding-aid" target="_blank">Finding Aid</a></div>
                    <div><a ex:href-content=".search" target="_blank">Search IISH collections</a></div>
                    <br>

                    <div ex:if-exists=".picture" class="thispicture">This picture: <a ex:href-content=".picture-link"
                                                                                      target="_blank"
                                                                                      title="about this picture"><span
                            ex:content=".picture" class="picture"></span></a></div>

                </div>
                <!-- tab 1 Timeline -->
                <div ex:role="view"
                     ex:viewClass="Timeline"
                     ex:label="View as timeline"
                     ex:start=".from"
                     ex:end=".to"
                     ex:topBandHeight="85"
                     ex:bottomBandHeight="15"
                     ex:colorKey=".p-o"
                     ex:colorCoder="p-o-colors"
                     ex:configuration="timelineConfig"
                        >
                </div>
                <!-- tab 2 Google Map-->
                <!--<div ex:role="view"
                    ex:viewClass="Map"
                    ex:label="View on map"
                    ex:latlng=".addressLatLng"
                    ex:center="50,-10"
                    ex:zoom="3"
                    ex:icon=".image"
                    ex:shapeWidth="30"
                    ex:shapeHeight="30"
                    >
                </div>-->
                <!-- tab 3 Details -->
                <!--<div ex:role="view"
                    ex:viewClass="Thumbnail"
                    ex:label="View details"
                    ex:showAll="true"
                    ex:possibleOrders=".label, .from, .size, .country"
                    >

                    <table ex:role="lens" class="item">
                    <tr>
                        <td width="150"><img ex:src-content=".image" alt=/></td>
                        <td width="650" class="item">
                            <span class="detailfont">
                            <div ex:content=".name" class="name"></div>
                            <div>Size: <span ex:content=".size" class="size"></span></div>
                            <div>Period: <span ex:content=".from" class="year"></span>&nbsp;-&nbsp;<span ex:content=".to" class="year"></span></div>

                            <div>Country: <span ex:content=".country" class="country"></span></div>
                            <div>Language: <span ex:content=".language" class="language"></span></div>
                            <div><a ex:href-content=".finding-aid" target="_blank">Finding Aid</a></div>
                            <div><a ex:href-content=".search" target="_blank">Search IISH collections</a></div>
                            <br>
                            <div ex:if-exists=".picture" class="thispicture">This picture: <a ex:href-content=".picture-link" target="_blank" title="about this picture"><span ex:content=".picture" class="picture"></span></a></div>

                            </span>
                        </td>
                    </tr>
                    </table>
                </div>
            </div>-->
                <div ex:role="coder" ex:coderClass="Color" id="p-o-colors">
                    <span ex:color="#cc0000">Person</span>

                    <span ex:color="#003399">Organization</span>
                </div>
        </td>
        <td id="sidebar" width="14%">
            <div id="exhibit-browse-panel">
                <strong>Search</strong>

                <div ex:role="facet" ex:facetClass="TextSearch"></div>
                <br>

                <div ex:role="facet" ex:expression=".country" ex:facetLabel="Country"></div>

                <div ex:role="facet" ex:expression=".language" ex:facetLabel="Language"></div>
                <div ex:role="facet" ex:expression=".date-acquired" ex:facetLabel="Date acquired"></div>
                <div ex:role="facet" ex:expression=".p-o" ex:facetLabel="Person/Organization"></div>
            </div>
        </td>
    </tr>
</table>