<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format">
  <xsl:output method="xml" indent="yes"/>
  
  <!--Global variables-->
  <xsl:variable name="list_label" select="'- '"/>
  <xsl:variable name="list_label2" select="'-- '"/>
  <xsl:variable name="new_line" select="'&#10;'"/>
  <xsl:variable name="list_break" select="'#'"/>
  
  <!-- Attribute Sets -->
  <xsl:attribute-set name="general-body">
    <xsl:attribute name="font-family">Inter</xsl:attribute>
    <xsl:attribute name="font-size">8pt</xsl:attribute>
  </xsl:attribute-set>
  
  <!-- SPG STYLESHEET GOES HERE -->

  <xsl:template match="/">
    <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:fox="http://xmlgraphics.apache.org/fop/extensions" xml:lang="en">
      
      <fo:layout-master-set>
        <fo:simple-page-master master-name="spg_report" page-height="8.5in" page-width="11in" margin="0.5in">
          <fo:region-body margin-bottom="0.6in"/>
          <fo:region-after extent="0.5in"/>
        </fo:simple-page-master>
      </fo:layout-master-set>
      
      <fo:declarations>
        <x:xmpmeta xmlns:x="adobe:ns:meta/">
          <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
            <rdf:Description rdf:about="" xmlns:dc="http://purl.org/dc/elements/1.1/">
              <dc:title><xsl:value-of select="SPG_REPORT/TITLE"/></dc:title>
              <dc:creator>The Joint Commission Department of Global Standards and Survery Methods</dc:creator>
            </rdf:Description>
          </rdf:RDF>
        </x:xmpmeta>
      </fo:declarations>

      
      <fo:page-sequence master-reference="spg_report" id="spg_report">
        <fo:title><xsl:value-of select="SPG_REPORT/TITLE"/></fo:title>
        

    <!--Footer information -->
        <fo:static-content flow-name = "xsl-region-after" role="artifact" font-family="Inter" font-size="8pt">
          <fo:block><fo:leader leader-pattern="rule" rule-thickness="1pt" color="black" leader-length="100%"/></fo:block>
          <fo:table table-layout="fixed" width="100%">
            <fo:table-column column-width="30%"/>
            <fo:table-column column-width="40%"/>
            <fo:table-column column-width="30%"/>
            <fo:table-body>
              <fo:table-row>
                <fo:table-cell display-align="center"> 
                  <fo:block   text-align="left"><xsl:value-of select="SPG_REPORT/TITLE"/></fo:block>
                </fo:table-cell>
                <fo:table-cell display-align="center">
                  <fo:block text-align="center">Page <fo:page-number/> of <fo:page-number-citation-last ref-id="spg_report"/></fo:block>
                </fo:table-cell>
                <fo:table-cell display-align="center">
                  <fo:block text-align="right">© <xsl:value-of select="substring-after(SPG_REPORT/RUN_DT, ', ')"/> Joint Commission</fo:block>
                </fo:table-cell>
              </fo:table-row>
            </fo:table-body>
          </fo:table>
        </fo:static-content>


        <!--Document Body-->        
        <fo:flow flow-name = "xsl-region-body" font-family="Inter" font-size="8pt" space-after="5pt">
            <xsl:for-each select="SPG_REPORT/COP">
                <xsl:choose>
                    <xsl:when test="contains(COP_TTL, 'Condition of Participation:')">
                        <fo:block font-family="Satoshi" font-weight="bold" font-size="18pt" break-before="page" keep-with-next="always" role="H1"> 
                            <xsl:value-of select="substring-after(COP_TTL, 'Condition of Participation: ')"/> (<xsl:value-of select="COP_NM"/>)
                        </fo:block>
                    </xsl:when>
                    <xsl:otherwise>
                        <fo:block font-family="Satoshi" font-weight="bold" font-size="18pt" break-before="page" keep-with-next="always" role="H1"> 
                            <xsl:value-of select="COP_TTL"/> (<xsl:value-of select="COP_NM"/>)
                        </fo:block>
                    </xsl:otherwise>
                </xsl:choose>

                <xsl:for-each select="SPG">
                    <fo:block keep-with-next="always"><fo:leader leader-pattern="rule" rule-thickness="2pt" color="black" leader-length="100%"/></fo:block>
                    <fo:block keep-with-next="always" font-family="Satoshi" font-size="16pt" space-after="8pt" role="H2">Survey Process</fo:block>
                
                    <xsl:call-template name="tag_text">
                      <xsl:with-param name="txt" select="SPG_TXT"/>
                    </xsl:call-template>
                  
                    <fo:table table-layout="fixed" width="100%" border="1pt solid black" space-before="12pt" space-after="12pt">
                        <fo:table-column column-width="55%"/>
                        <fo:table-column column-width="45%"/>
                        <fo:table-body>
                            <fo:table-row keep-with-next="always">
                                <fo:table-cell role = "TH" border-right="1pt solid black" padding="5pt">
                                    <fo:block font-family="Satoshi" font-size="12pt" text-align="left" space-after="8pt">Joint Commission Standards/EPs</fo:block>
                                </fo:table-cell>
                                <fo:table-cell  role = "TH" padding="5pt">
                                    <fo:block font-family="Satoshi" font-size="12pt" text-align="left" space-after="8pt"><xsl:value-of select="/SPG_REPORT/PROGRAM"/> CoPs</fo:block>
                                </fo:table-cell>
                            </fo:table-row>
                            <fo:table-row border="1pt solid black" border-before-width.conditionality="retain" border-after-width.conditionality="retain">
                                <fo:table-cell border-right="1pt solid black" padding="5pt">
                                    <xsl:choose>
                                        <xsl:when test="count(EP) = 0">
                                            <fo:block></fo:block>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:for-each select ="EP">
                                                <fo:block keep-with-next="always" space-before="8pt" font-family="Satoshi" font-size="8pt" font-weight="bold">
                                                    <xsl:value-of select="STD_LBL"/>, EP <xsl:value-of select="EP_LBL"/>
                                                </fo:block>
                                                <xsl:call-template name="tag_text">
                                                  <xsl:with-param name="txt" select="EP_TXT"/>
                                                </xsl:call-template>
                                            </xsl:for-each>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </fo:table-cell>
                                <fo:table-cell padding="5pt">
                                    <xsl:choose>
                                        <xsl:when test="count(COP_ELE) = 0">
                                            <fo:block></fo:block>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:for-each select ="COP_ELE">
                                                <fo:block keep-with-next="always" space-before="8pt" font-family="Satoshi" font-size="8pt" font-weight="bold">
                                                    <xsl:value-of select="COP_ELE_NM"/>
                                                </fo:block>
                                                <fo:block linefeed-treatment="preserve" space-after="8pt" keep-with-previous="always">
                                                    <xsl:value-of select="COP_TXT"/>
                                                </fo:block>
                                            </xsl:for-each>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </fo:table-cell>
                            </fo:table-row>
                        </fo:table-body>
                    </fo:table>
                </xsl:for-each>
            </xsl:for-each>
        </fo:flow>
      </fo:page-sequence>
    </fo:root>
  </xsl:template>

  <!-- Template for list tagging -->
    <xsl:template name="tag_text">
        <xsl:param name="txt"/>
        <xsl:choose>
            <xsl:when test="contains($txt, $new_line)">
                <xsl:choose>
                    <!--Skip extra line breaks-->
                    <xsl:when test="starts-with($txt, $new_line)">
                        <xsl:call-template name="tag_text">
                            <xsl:with-param name="txt" select="substring-after($txt, $new_line)"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="starts-with(normalize-space($txt), $list_label)">
                        <!--recurring loop to create a list of list elements -->
                        <xsl:call-template name="create_list_list">
                            <xsl:with-param name="txt" select="$txt"/>
                            <xsl:with-param name="list_txt"/>
                        </xsl:call-template>
                        
                    </xsl:when>
                    <xsl:otherwise> <!-- if line isn't a list item -->
                        <xsl:if test="string-length(substring-before($txt, $new_line)) > 0">
                          <xsl:choose>
                            <xsl:when test="substring-before($txt, $new_line) = 'Interview'">
                              <fo:block font-family="Satoshi" font-size="10pt" font-weight="bold" text-decoration="underline" space-before="8pt" keep-with-next="always" role="H3"><xsl:value-of select="substring-before($txt, $new_line)"/></fo:block>
                            </xsl:when>
                            <xsl:when test="substring-before($txt, $new_line) = 'Observation'">
                              <fo:block font-family="Satoshi" font-size="10pt" font-weight="bold" text-decoration="underline" space-before="8pt" keep-with-next="always" role="H3"><xsl:value-of select="substring-before($txt, $new_line)"/></fo:block>
                            </xsl:when>
                            <xsl:when test="substring-before($txt, $new_line) = 'Document Review'">
                              <fo:block font-family="Satoshi" font-size="10pt" font-weight="bold" text-decoration="underline" space-before="8pt" keep-with-next="always" role="H3"><xsl:value-of select="substring-before($txt, $new_line)"/></fo:block>
                            </xsl:when>
                            <xsl:when test="substring-before($txt, $new_line) = 'General'">
                              <fo:block font-family="Satoshi" font-size="10pt" font-weight="bold" space-before="8pt" keep-with-next="always" role="H3"><xsl:value-of select="substring-before($txt, $new_line)"/></fo:block>
                            </xsl:when>
                            <xsl:when test="substring-before($txt, $new_line) = 'Patient Health Record'">
                              <fo:block font-family="Satoshi" font-size="10pt" font-weight="bold" space-before="8pt" keep-with-next="always" role="H3"><xsl:value-of select="substring-before($txt, $new_line)"/></fo:block>
                            </xsl:when>
                            <xsl:when test="starts-with(substring-before($txt, $new_line), 'Personnel/Credential File')">
                              <fo:block font-family="Satoshi" font-size="10pt" font-weight="bold" space-before="8pt" keep-with-next="always" role="H3"><xsl:value-of select="substring-before($txt, $new_line)"/></fo:block>
                            </xsl:when>
                            <xsl:when test="starts-with(substring-before($txt, $new_line), 'Credential File')">
                              <fo:block font-family="Satoshi" font-size="10pt" font-weight="bold" space-before="8pt" keep-with-next="always" role="H3"><xsl:value-of select="substring-before($txt, $new_line)"/></fo:block>
                            </xsl:when>
                            
                            <xsl:otherwise>
                              <fo:block font-size="8pt"><xsl:value-of select="substring-before($txt, $new_line)"/></fo:block>
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:if>
                        
                        <xsl:variable name="txt" select="substring-after($txt, $new_line)"/>
                        
                        <xsl:call-template name="tag_text">
                            <xsl:with-param name="txt" select="$txt"/>
                        </xsl:call-template>
                        
                    </xsl:otherwise>
                </xsl:choose>              
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="starts-with(normalize-space($txt), $list_label)">
                        <fo:list-block>
                            <fo:list-item>
                                <fo:list-item-label><fo:block font-size="8pt" start-indent="10pt">•</fo:block></fo:list-item-label>
                                <fo:list-item-body><fo:block font-size="8pt" start-indent="20pt"><xsl:value-of select="substring-after($txt, $list_label)"/></fo:block></fo:list-item-body>
                            </fo:list-item>
                        </fo:list-block>                        
                    </xsl:when>
                    <xsl:otherwise>
                        <fo:block font-size="8pt"><xsl:value-of select="$txt"/></fo:block>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
    
    
    <xsl:template name="create_list_list">
        <xsl:param name="txt"/>
        <xsl:param name="list_txt"/>
        <xsl:choose>
            <!--Skip extra line breaks-->
            <xsl:when test="starts-with($txt, $new_line)">
                <xsl:call-template name="create_list_list">
                    <xsl:with-param name="txt" select="substring-after($txt, $new_line)"/>
                    <xsl:with-param name="list_txt" select="$list_txt"/>
                </xsl:call-template>
            </xsl:when>
            <!--Loop through list items -->
            <xsl:when test="starts-with(normalize-space($txt), $list_label) or starts-with(normalize-space($txt), $list_label2)">
                <xsl:choose>
                    <xsl:when test="contains($txt, $new_line)">
                        <xsl:variable name="list_txt" select="concat($list_txt, substring-before($txt, $new_line), $list_break)"/>
                        <xsl:variable name="txt" select="substring-after($txt, $new_line)"/>
                        <xsl:call-template name="create_list_list">
                            <xsl:with-param name="txt" select="$txt"/>
                            <xsl:with-param name="list_txt" select="$list_txt"/>
                        </xsl:call-template>
                    </xsl:when>
                    
                    <xsl:otherwise>
                        <xsl:variable name="list_txt" select="concat($list_txt, $txt, $list_break)"/>
                        
                        <fo:list-block>
                            <!--call template to print list --> 
                            <xsl:call-template name="tag_list">
                                <xsl:with-param name="list_txt" select="$list_txt"/>
                                <xsl:with-param name="sublist_txt"/>
                            </xsl:call-template>
                        </fo:list-block>
                    </xsl:otherwise>
                    
                </xsl:choose>
            </xsl:when>
            
            <xsl:otherwise>
                <!--call template to print list --> 
                <fo:list-block>
                    <xsl:call-template name="tag_list">
                        <xsl:with-param name="list_txt" select="$list_txt"/>
                        <xsl:with-param name="sublist_txt"/>
                    </xsl:call-template>
                </fo:list-block>
                
                <xsl:call-template name="tag_text">
                    <xsl:with-param name="txt" select="$txt"/>
                </xsl:call-template>
                
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
    
    
    <xsl:template name="tag_list">
        <xsl:param name="list_txt" />
        <xsl:param name="sublist_txt" />
        <xsl:choose>
            <!-- If the list contains multiple items, tag one, redfine variable, pass back through --> 
            <xsl:when test="string-length($list_txt)-string-length(translate($list_txt, $list_break, ''))>1">
                <xsl:choose>
                    <xsl:when test="starts-with(normalize-space($list_txt), $list_label2)">
                        <xsl:variable name="sublist_txt" select="concat($sublist_txt, substring-before($list_txt, $list_break), $list_break)"/>
                        <xsl:variable name="list_txt" select="substring-after($list_txt, $list_break)"/>
                        
                        <xsl:call-template name="tag_list">
                            <xsl:with-param name="list_txt" select="$list_txt"/>
                            <xsl:with-param name="sublist_txt" select="$sublist_txt"/>
                        </xsl:call-template>
                        
                    </xsl:when>               
                    <xsl:otherwise>
                        <xsl:if test="string-length($sublist_txt)>1">
                            <fo:list-item><fo:list-item-label><fo:block></fo:block></fo:list-item-label><fo:list-item-body>
                                    <fo:list-block>
                                        <xsl:call-template name="tag_sublist">
                                            <xsl:with-param name="sublist_txt" select="$sublist_txt"/>
                                        </xsl:call-template>
                                    </fo:list-block>                 
                                </fo:list-item-body></fo:list-item>
                        </xsl:if>
                        
                        <fo:list-item>
                            <fo:list-item-label><fo:block font-size="8pt" start-indent="10pt">•</fo:block></fo:list-item-label>
                            <fo:list-item-body><fo:block font-size="8pt" start-indent="20pt"><xsl:value-of select="substring-after(substring-before($list_txt, $list_break), $list_label)"/></fo:block></fo:list-item-body>
                        </fo:list-item>
                        <xsl:variable name="list_txt" select="substring-after($list_txt, $list_break)"/>
                        
                        <xsl:call-template name="tag_list">
                            <xsl:with-param name="list_txt" select="$list_txt"/>
                            <xsl:with-param name="sublist_txt" select="''"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
                
            </xsl:when>
            <!-- Tag last list item --> 
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="starts-with(normalize-space($list_txt), $list_label2)">
                        <xsl:variable name="sublist_txt" select="concat($sublist_txt, $list_txt)"/>
                        <fo:list-item><fo:list-item-label><fo:block></fo:block></fo:list-item-label><fo:list-item-body>
                                <fo:list-block>
                                    <xsl:call-template name="tag_sublist">
                                        <xsl:with-param name="sublist_txt" select="$sublist_txt"/>
                                    </xsl:call-template>
                                </fo:list-block>
                            </fo:list-item-body></fo:list-item>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:if test="string-length($sublist_txt)>1">
                            <fo:list-item><fo:list-item-label><fo:block></fo:block></fo:list-item-label><fo:list-item-body>
                                    <fo:list-block>
                                        <xsl:call-template name="tag_sublist">
                                            <xsl:with-param name="sublist_txt" select="$sublist_txt"/>
                                        </xsl:call-template>
                                    </fo:list-block>
                                </fo:list-item-body></fo:list-item>
                        </xsl:if>
                        
                        <fo:list-item>
                            <fo:list-item-label><fo:block font-size="8pt" start-indent = "10pt">•</fo:block></fo:list-item-label>
                            <fo:list-item-body><fo:block font-size="8pt" start-indent="20pt"><xsl:value-of select="substring-before(substring-after($list_txt, $list_label), $list_break)"/></fo:block></fo:list-item-body>
                        </fo:list-item>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="tag_sublist">
        <xsl:param name="sublist_txt"/>
        <xsl:choose>
            <!-- If the list contains multiple items, tag one, redfine variable, pass back through --> 
            <xsl:when test="string-length($sublist_txt)-string-length(translate($sublist_txt, $list_break, ''))>1">
                <fo:list-item start-indent="20pt">
                    <fo:list-item-label><fo:block font-size="8pt" start-indent="30pt">•</fo:block></fo:list-item-label>
                    <fo:list-item-body><fo:block font-size="8pt" start-indent="40pt"><xsl:value-of select="substring-after(substring-before($sublist_txt, $list_break), $list_label)"/></fo:block></fo:list-item-body>
                </fo:list-item>
                <xsl:variable name="sublist_txt" select="substring-after($sublist_txt, $list_break)"/>
                
                <xsl:call-template name="tag_sublist">
                    <xsl:with-param name="sublist_txt" select="$sublist_txt"/>
                </xsl:call-template>
                
            </xsl:when>
            <!-- Tag last list item --> 
            <xsl:otherwise>
                <xsl:if test="starts-with(normalize-space($sublist_txt), $list_label2)">
                    <fo:list-item start-indent="20pt">
                        <fo:list-item-label><fo:block font-size="8pt" start-indent="30pt">•</fo:block></fo:list-item-label>
                        <fo:list-item-body><fo:block font-size="8pt" start-indent="40pt"><xsl:value-of select="substring-before(substring-after($sublist_txt, $list_label), $list_break)"/></fo:block></fo:list-item-body>
                    </fo:list-item>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
    
</xsl:stylesheet>
