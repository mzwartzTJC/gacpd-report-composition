<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format">
    <xsl:output method="xml" indent="yes"/>

<!--Global variables-->
<xsl:variable name="list_label" select="'- '"/>
<xsl:variable name="new_line" select="'&#10;'"/>
<xsl:variable name="list_break" select="'#'"/>

<xsl:template match="/">
    <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:fox="http://xmlgraphics.apache.org/fop/extensions" xml:lang="en">
              
        <fo:layout-master-set>
            <fo:simple-page-master master-name="prepub_first_page" page-height="11in" page-width="8.5in" margin = "0.5in">
                <fo:region-body margin-bottom="0.8in"/>
                <fo:region-after extent="0.75in"/>
            </fo:simple-page-master>
            <fo:simple-page-master master-name="prepub_body" page-height="11in" page-width="8.5in" margin-top="0.75in" margin="0.25in">
                <fo:region-body margin-bottom="0.8in" margin-top="0.8in"/>
                <fo:region-before extent="0.75in"/>
                <fo:region-after extent="0.75in"/>
            </fo:simple-page-master>
                
            <fo:page-sequence-master master-name="prepub_pages">
                <fo:repeatable-page-master-alternatives>
                    <fo:conditional-page-master-reference master-reference="prepub_first_page" page-position="first"/>
                    <fo:conditional-page-master-reference master-reference="prepub_body" page-position="rest"/>
                </fo:repeatable-page-master-alternatives>
            </fo:page-sequence-master>
        
        </fo:layout-master-set>

        <fo:declarations>
            <x:xmpmeta xmlns:x="adobe:ns:meta/">
            <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
                <rdf:Description rdf:about="" xmlns:dc="http://purl.org/dc/elements/1.1/">
                    <dc:title>Prepublication Report</dc:title>
                    <dc:creator>The Joint Commission Department of Global Standards and Survery Methods</dc:creator>
                </rdf:Description>
            </rdf:RDF>
            </x:xmpmeta>
        </fo:declarations>

        <fo:page-sequence master-reference="prepub_pages" id="prepub_pages">
            <!--Header infromation--> 
            <fo:static-content flow-name="xsl-region-before" role="artifact">
            <fo:block-container absolute-position="absolute">
                <fo:block><fo:external-graphic src="images/JC_logo_CMYK_TM.jpg" content-width = "120" content-height = "24" fox:alt-text="Joint Commission Logo"/></fo:block>
            </fo:block-container>
                <fo:block start-indent="2.5in" font-family="Satoshi" color="#1f336b" text-align="left" font-size="11pt">Prepublication Requirements <fo:inline color="black" font-style="italic">continued</fo:inline></fo:block>
                <fo:block start-indent="2.5in" font-family="Inter" text-align="left" font-size="10pt"><xsl:value-of select="REPORT/POST_DT"/></fo:block>
                <fo:block-container background-color="#fbc24f" height="5" space-before="10pt"><fo:block/></fo:block-container>            
            </fo:static-content>

            <!--Footer information-->
            <fo:static-content flow-name = "xsl-region-after" role="artifact">
            <fo:block><fo:leader leader-pattern="rule" rule-thickness="1pt" color="black" leader-length="100%"/></fo:block>
                 <fo:table table-layout="fixed" width="100%">
                    <fo:table-column column-width="25%"/>
                    <fo:table-column column-width="50%"/>
                    <fo:table-column column-width="25%"/>
                    <fo:table-body>
                        <fo:table-row>
                            <fo:table-cell display-align="center"> 
                                <fo:block></fo:block>
                            </fo:table-cell>
                            <fo:table-cell display-align="center">
                                <fo:block font-size="8pt" text-align="center">Page <fo:page-number/> of <fo:page-number-citation-last ref-id="prepub_pages"/></fo:block>
                                <fo:block font-size="8pt" text-align="center">Prepublication Standards</fo:block>
                                <fo:block font-size="8pt" text-align="center">Effective <xsl:value-of select="REPORT/EFC_DT"/></fo:block>
                            </fo:table-cell>
                            <fo:table-cell display-align="center">
                                <fo:block font-size="8pt" text-align="right">© <xsl:value-of select="substring(REPORT/EFC_DT, string-length(REPORT/EFC_DT) - 3)"/> The Joint Commission</fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </fo:table-body>
                </fo:table>
            </fo:static-content>

            <fo:flow flow-name = "xsl-region-body" font-family="Inter" font-size="10pt" space-after="5pt">
            
                <fo:block-container absolute-position="absolute" top="0.25in">
                    <fo:block><fo:external-graphic src="images/JC_logo_CMYK_TM.jpg" content-width = "160" content-height = "32" fox:alt-text="Joint Commission Logo"/></fo:block>
                </fo:block-container>
                <fo:block-container float="right" absolute-position="absolute" left="3.25in" top="0in">
                    <fo:block font-size= "36pt" color="#1f336b" font-family="Satoshi" font-weight="bold">Prepublication Requirements</fo:block>
                </fo:block-container>

                <fo:block start-indent="0.25in" space-before="1.25in" font-weight="bold"> &#x2022; Issued <xsl:value-of select="REPORT/POST_DT"/>  &#x2022;</fo:block>
                
                <fo:block-container background-color="#fbc24f" height="80" space-before="7pt" role="artifact"><fo:block></fo:block></fo:block-container>

                <fo:block-container float="left" absolute-position="absolute" top="1.65in">
                    <fo:block start-indent="0.10in"><fo:external-graphic src="images/tjc-requirement.png" fox:alt-text="Joint Commission Requirement" content-width = "65" content-height = "57.5" /></fo:block>
                </fo:block-container>
                <fo:block-container float="left" absolute-position="absolute" left="1.25in" top="1.75in">
                    <fo:block font-size= "18pt" color="#1f336b" role="H1" font-family="Satoshi" font-weight="bold"><xsl:value-of select="REPORT/TITLE"/></fo:block>
                </fo:block-container>

                <fo:block space-before="10pt" font-size="10pt">Joint Commission has approved the following revisions for prepublication. While revised requirements are published in the semiannual updates to the print manuals (as well as in the online E-dition®), accredited organizations and paid subscribers can also view them in the monthly periodical The Joint Commission Perspectives®. To begin your subscription, call 800-746-6578 or visit <fo:basic-link external-destination= "http://www.jcrinc.com">http://www.jcrinc.com</fo:basic-link>.</fo:block>
                <fo:block-container background-color="#fbc24f" height="5" space-before="10pt"><fo:block/></fo:block-container>

                <fo:block color="#1f336b" font-size="9pt" font-family="Satoshi" font-weight="bold" space-before="10pt">APPLICABLE TO THE <xsl:value-of select="REPORT/PROGRAM/PROGRAM_DS"/> ACCREDITATION PROGRAM</fo:block>

                <fo:block font-family="Inter" font-weight="bold" font-size="9pt"><xsl:value-of select="REPORT/EFC_DT"/></fo:block>

                
                <xsl:for-each select="REPORT/PROGRAM/CHAPTER">
                    <fo:block color="#1f336b" role="H2" font-family="Satoshi" font-size="13pt" space-before="10pt" keep-with-next.within-page="always"><xsl:value-of select="CHAPTER_NM"/></fo:block>
                    <fo:block><fo:leader leader-pattern="rule" rule-thickness="1pt" color="gray" leader-length="100%"/></fo:block>

                        <xsl:for-each select="STANDARD">
                            <fo:block role="H3" font-family="Satoshi" font-size="13pt" font-weight="bold"><xsl:value-of select="STANDARD_NM"/></fo:block>
                            <fo:block font-size="10pt"><xsl:value-of select="STD_TX"/></fo:block>
                            

                            <fo:table table-layout="fixed" width="100%">
                                <fo:table-column column-width="15%"/>
                                <fo:table-column column-width="85%"/>
                                <fo:table-body>
                                    <fo:table-row>
                                        <fo:table-cell role = "TH" number-columns-spanned="2" padding-top="5pt" padding-bottom="5pt" keep-with-next.within-page="always">
                                        <fo:block role="H4" text-align="center" font-weight="bold" border-bottom="1pt gray" keep-with-next.within-page="always">Element(s) of performance for <xsl:value-of select="STANDARD_NM"/></fo:block>
                                        </fo:table-cell>
                                    </fo:table-row>
                            
                                    <xsl:for-each select="EP">
                                        <xsl:if test="EP_TX_PREV">
                                            <fo:table-row>
                                                <fo:table-cell role="TD" start-indent="10pt" border-bottom="1pt solid gray" padding="5pt"><fo:block font-size="10pt"><xsl:value-of select="EP_LBL_PREV"/></fo:block></fo:table-cell>
                                                <fo:table-cell padding-left="10pt" border-bottom="1pt solid gray" padding="5pt">
                                                    <xsl:call-template name="tag_text">
                                                        <xsl:with-param name="txt" select="EP_TX_PREV"/>
                                                    </xsl:call-template>
                                                    
                                                    <xsl:if test="DOC">
                                                        <fo:block keep-with-previous.within-page="always" margin="5pt">
                                                            <fo:inline baseline-shift="-1.5pt">
                                                                <fo:external-graphic src="url('file:///C:/Users/MZwartz/OneDrive%20-%20The%20Joint%20Commission/Desktop/GitHub/XML_stylesheets/images/doc_icon.png')" content-height="10pt" fox:alt-text="Documentation icon"/>
                                                            </fo:inline>  
                                                            <fo:inline>  Documentation is required.</fo:inline>
                                                        </fo:block>
                                                    </xsl:if>
                                                </fo:table-cell>
                                            </fo:table-row>
                                        </xsl:if>
                                
                                        <xsl:if test="EP_TX">                     
                                            <fo:table-row>
                                                <fo:table-cell start-indent="10pt" border-bottom="1pt solid gray" padding="5pt"><fo:block  font-size="10pt"><xsl:value-of select="EP_LBL"/></fo:block></fo:table-cell>
                                                
                                                <fo:table-cell padding-left="10pt" border-bottom="1pt solid gray" padding="5pt">
                                                    <xsl:call-template name="tag_text">
                                                        <xsl:with-param name="txt" select="EP_TX"/>
                                                    </xsl:call-template>
                                                    
                                                    <xsl:if test="DOC">
                                                        <fo:block keep-with-previous.within-page="always" margin="5pt">
                                                            <fo:inline baseline-shift="-1.5pt">
                                                                <fo:external-graphic src="url('file:///C:/Users/MZwartz/OneDrive%20-%20The%20Joint%20Commission/Desktop/GitHub/XML_stylesheets/images/doc_icon.png')" content-height="10pt" fox:alt-text="Documentation icon"/>
                                                            </fo:inline>  
                                                            <fo:inline>  Documentation is required.</fo:inline>
                                                        </fo:block>
                                                    </xsl:if>
                                                </fo:table-cell>
                                            </fo:table-row>
                                        </xsl:if>
                                    </xsl:for-each>
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
                    <xsl:when test="starts-with(normalize-space($txt), $list_label)">
                        <!--recurring loop to create a list of list elements -->
                        <xsl:call-template name="create_list_list">
                            <xsl:with-param name="txt" select="$txt"/>
                            <xsl:with-param name="list_txt"/>
                        </xsl:call-template>
            
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:if test="string-length(substring-before($txt, $new_line)) > 0">
                            <fo:block font-size="10pt"><xsl:value-of select="substring-before($txt, $new_line)"/></fo:block>
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
                                <fo:list-item-label><fo:block font-size="10pt" end-indent="label-end()">•</fo:block></fo:list-item-label>
                                <fo:list-item-body><fo:block font-size="10pt" start-indent="10pt"><xsl:value-of select="substring-after($txt, $list_label)"/></fo:block></fo:list-item-body>
                            </fo:list-item>
                        </fo:list-block>                        
                    </xsl:when>
                    <xsl:otherwise>
                        <fo:block font-size="10pt"><xsl:value-of select="$txt"/></fo:block>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>


    <xsl:template name="create_list_list">
        <xsl:param name="txt"/>
        <xsl:param name="list_txt"/>
        <xsl:choose>
            <xsl:when test="starts-with(normalize-space($txt), $list_label)">
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
        <xsl:choose>
            <!-- If the list contains multiple items, tag one, redfine variable, pass back through --> 
            <xsl:when test="string-length($list_txt)-string-length(translate($list_txt, $list_break, ''))>1">
                <fo:list-item>
                    <fo:list-item-label><fo:block font-size="10pt" end-indent="label-end()">•</fo:block></fo:list-item-label>
                    <fo:list-item-body><fo:block font-size="10pt" start-indent="10pt"><xsl:value-of select="substring-after(substring-before($list_txt, $list_break), $list_label)"/></fo:block></fo:list-item-body>
                </fo:list-item>
                <xsl:variable name="list_txt" select="substring-after($list_txt, $list_break)"/>
                
                <xsl:call-template name="tag_list">
                    <xsl:with-param name="list_txt" select="$list_txt"/>
                </xsl:call-template>
                
            </xsl:when>
            <!-- Tag last list item --> 
            <xsl:otherwise>
                <fo:list-item>
                    <fo:list-item-label><fo:block font-size="10pt" end-indent="label-end()">•</fo:block></fo:list-item-label>
                    <fo:list-item-body><fo:block font-size="10pt" start-indent="10pt"><xsl:value-of select="substring-before(substring-after($list_txt, $list_label), $list_break)"/></fo:block></fo:list-item-body>
                </fo:list-item>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>

</xsl:stylesheet>
