<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor version="1.0.0"
  xsi:schemaLocation="http://www.opengis.net/sld http://schemas.opengis.net/sld/1.0.0/StyledLayerDescriptor.xsd" xmlns="http://www.opengis.net/sld"
  xmlns:ogc="http://www.opengis.net/ogc" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <NamedLayer>
    <Name>mzoologia:recursosgeoreferenciacio</Name>
    <UserStyle>
      <Name>mzoologia:recursosgeoreferenciacio</Name>      
      <FeatureTypeStyle>
        <Rule>                 
            <ogc:Filter>
              <ogc:PropertyIsEqualTo>
                <ogc:PropertyName>tipus_geom</ogc:PropertyName>
                <ogc:Literal>P</ogc:Literal>
              </ogc:PropertyIsEqualTo>              
            </ogc:Filter>             
            <PolygonSymbolizer>
                  <Fill>
                    <CssParameter name="fill">#a5ff96</CssParameter>
                  </Fill>
                  <Stroke>
                      <CssParameter name="stroke">#169b00</CssParameter>
                      <CssParameter name="stroke-width">1</CssParameter>
                  </Stroke>
            </PolygonSymbolizer>       
        </Rule>
        <Rule>
            <ogc:Filter>
              <ogc:PropertyIsEqualTo>
                <ogc:PropertyName>tipus_geom</ogc:PropertyName>
                <ogc:Literal>A</ogc:Literal>
              </ogc:PropertyIsEqualTo>              
            </ogc:Filter>             
            <LineSymbolizer>
                <Stroke>
                  <CssParameter name="stroke">#169b00</CssParameter>
                </Stroke>
            </LineSymbolizer>                                     
        </Rule>
        <Rule>
            <ogc:Filter>
              <ogc:PropertyIsEqualTo>
                <ogc:PropertyName>tipus_geom</ogc:PropertyName>
                <ogc:Literal>T</ogc:Literal>
              </ogc:PropertyIsEqualTo>              
            </ogc:Filter>             
            <PointSymbolizer>
            <Graphic>
              <Mark>              
                <Fill>
                  <CssParameter name="fill">
                    <ogc:Literal>#a5ff96</ogc:Literal>
                  </CssParameter>
                </Fill>
                <Stroke>
                  <CssParameter name="stroke">
                    <ogc:Literal>#169b00</ogc:Literal>
                  </CssParameter>
                  <CssParameter name="stroke-width">
                    <ogc:Literal>1</ogc:Literal>
                  </CssParameter>
              </Stroke>
            </Mark>
            <Opacity>
              <ogc:Literal>1.0</ogc:Literal>
            </Opacity>
            <Size>
              <ogc:Literal>5</ogc:Literal>
            </Size>
          </Graphic>
        </PointSymbolizer>
        </Rule>
      </FeatureTypeStyle>
    </UserStyle>
  </NamedLayer>
</StyledLayerDescriptor>