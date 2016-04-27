<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:hl7="urn:hl7-org:v3" xmlns:util="http://www.browsersoft.com/">

    <xsl:import href="mxl2html-translate-source.xsl"/>

    <xsl:template name="create-header-row">
        <xsl:param name="cols"/>
        <xsl:for-each select="$cols/cols/col">
            <xsl:text disable-output-escaping="yes">&lt;th width="</xsl:text>
            <xsl:value-of select="@width"/>%<xsl:text disable-output-escaping="yes">"&gt;</xsl:text>
            <xsl:value-of select="."/>
            <xsl:text disable-output-escaping="yes">&lt;/th&gt;</xsl:text>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="create-header-row-vitals">
        <xsl:param name="cols"/>
        <xsl:for-each select="$cols/cols/col">
            <xsl:text disable-output-escaping="yes">&lt;th width="</xsl:text>
            <xsl:value-of select="@width"/>px<xsl:text disable-output-escaping="yes">"&gt;</xsl:text>
            <xsl:value-of select="."/>
            <xsl:text disable-output-escaping="yes">&lt;/th&gt;</xsl:text>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="get-source-name">
        <xsl:param name="id-tag"/>
        <xsl:variable name="tmp">
            <xsl:for-each select="$id-tag[(@root != 'RESULTTYPE') and (@root != 'REPORTTYPE')]">
                <xsl:call-template name="translate-source">
                    <xsl:with-param name="id-tag" select="."/>
                </xsl:call-template>
            </xsl:for-each>
        </xsl:variable>
        <xsl:value-of select="normalize-space($tmp)"/>
    </xsl:template>

    <xsl:template name="get-code-display">
        <xsl:param name="code-tag"/>
        <xsl:choose>
            <xsl:when test="ALLERGY_ORIGINAL">
                <xsl:value-of select="$code-tag/hl7:originalText"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$code-tag/@displayName"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="get-value-display">
        <xsl:param name="value-tag"/>
        <xsl:choose>
            <xsl:when test="$value-tag/@displayName">
                <xsl:value-of select="$value-tag/@displayName"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value-tag"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="get-surgeon-name">
        <xsl:param name="name-tag"/>
        <xsl:if test="$name-tag/SURGEON_LAST !=''">
            <xsl:value-of select="$name-tag/SURGEON_LAST"/>
            <xsl:if test="$name-tag/SURGEON_SUFFIX != ''">
                <xsl:text> </xsl:text>
                <xsl:value-of select="$name-tag/SURGEON_SUFFIX"/>
            </xsl:if>
            <xsl:text>, </xsl:text>
            <xsl:value-of select="$name-tag/SURGEON_FIRST"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="$name-tag/SURGEON_MIDDLE"/>
        </xsl:if>
    </xsl:template>

    <xsl:template name="get-attending-provider-name">
        <xsl:param name="name-tag"/>
        <xsl:if test="$name-tag/ATTENDING_PROVIDER_LAST !=''">
            <xsl:value-of select="$name-tag/ATTENDING_PROVIDER_LAST"/>
            <xsl:if test="$name-tag/ATTENDING_PROVIDER_SUFFIX != ''">
                <xsl:text> </xsl:text>
                <xsl:value-of select="$name-tag/ATTENDING_PROVIDER_SUFFIX"/>
            </xsl:if>
            <xsl:text>, </xsl:text>
            <xsl:value-of select="$name-tag/ATTENDING_PROVIDER_FIRST"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="$name-tag/ATTENDING_PROVIDER_MIDDLE"/>
        </xsl:if>
    </xsl:template>

    <xsl:template name="get-lastupdateby-name">
        <xsl:param name="name-tag"/>
        <xsl:if test="$name-tag/LAST_UPDATED_BY_LAST !=''">
            <xsl:value-of select="$name-tag/LAST_UPDATED_BY_LAST"/>
            <xsl:if test="$name-tag/LAST_UPDATED_BY_SUFFIX != ''">
                <xsl:text> </xsl:text>
                <xsl:value-of select="$name-tag/LAST_UPDATED_BY_SUFFIX"/>
            </xsl:if>
            <xsl:text>, </xsl:text>
            <xsl:value-of select="$name-tag/LAST_UPDATED_BY_FIRST"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="$name-tag/LAST_UPDATED_BY_MIDDLE"/>
        </xsl:if>
    </xsl:template>

    <xsl:template name="get-performer-name">
        <xsl:param name="name-tag"/>
        <xsl:if test="$name-tag/PERFORMER_LAST !=''">
            <xsl:value-of select="$name-tag/PERFORMER_LAST"/>
            <xsl:if test="$name-tag/PERFORMER_SUFFIX != ''">
                <xsl:text> </xsl:text>
                <xsl:value-of select="$name-tag/PERFORMER_SUFFIX"/>
            </xsl:if>
            <xsl:text>, </xsl:text>
            <xsl:value-of select="$name-tag/PERFORMER_FIRST"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="$name-tag/PERFORMER_MIDDLE"/>
        </xsl:if>
    </xsl:template>

    <xsl:template name="get-ordering-provider-name">
        <xsl:param name="name-tag"/>
        <xsl:if test="$name-tag/ORDERING_PROVIDER_LAST !=''">
            <xsl:value-of select="$name-tag/ORDERING_PROVIDER_LAST"/>
            <xsl:if test="$name-tag/ORDERING_PROVIDER_SUFFIX != ''">
                <xsl:text> </xsl:text>
                <xsl:value-of select="$name-tag/ORDERING_PROVIDER_SUFFIX"/>
            </xsl:if>
            <xsl:text>, </xsl:text>
            <xsl:value-of select="$name-tag/ORDERING_PROVIDER_FIRST"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="$name-tag/ORDERING_PROVIDER_MIDDLE"/>
        </xsl:if>
    </xsl:template>

    <xsl:template name="get-lastrewiewedby-name">
        <xsl:param name="name-tag"/>
        <xsl:if test="$name-tag/LAST_REVIEWED_BY_LAST !=''">
            <xsl:value-of select="$name-tag/LAST_REVIEWED_BY_LAST"/>
            <xsl:if test="$name-tag/LAST_REVIEWED_BY_SUFFIX != ''">
                <xsl:text> </xsl:text>
                <xsl:value-of select="$name-tag/LAST_REVIEWED_BY_SUFFIX"/>
            </xsl:if>
            <xsl:text>, </xsl:text>
            <xsl:value-of select="$name-tag/LAST_REVIEWED_BY_FIRST"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="$name-tag/LAST_REVIEWED_BY_MIDDLE"/>
        </xsl:if>
    </xsl:template>

    <xsl:template name="get-verifier-name">
        <xsl:param name="name-tag"/>
        <xsl:if test="VERIFIER_LAST !=''">
            <xsl:value-of select="VERIFIER_LAST"/>
            <xsl:if test="VERIFIER_SUFFIX != ''">
                <xsl:text> </xsl:text>
                <xsl:value-of select="$name-tag/VERIFIER_SUFFIX"/>
            </xsl:if>
            <xsl:text>, </xsl:text>
            <xsl:value-of select="$name-tag/VERIFIER_FIRST"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="$name-tag/VERIFIERY_MIDDLE"/>
        </xsl:if>
    </xsl:template>

    <xsl:template name="create-fake-tr">
        <xsl:param name="cols"/>
        <tr class="fake-header-row">
            <xsl:for-each select="$cols/cols/col">
                <td>
                    <div class="fake-th">
                        <xsl:value-of select="normalize-space(.)"/>
                    </div>
                </td>
            </xsl:for-each>
        </tr>
    </xsl:template>

    <!-- get item of map, ie. $user_info, can be called by:
        <xsl:call-template name="get-map-item">
                        <xsl:with-param name="map" select="$portal_info"/>
                        <xsl:with-param name="item-id" select="'PAT_ASSIGNAUTH'"/>
         </xsl:call-template>
    -->
    <xsl:template name="get-map-item">
        <xsl:param name="map"/>
        <xsl:param name="item-id"/>
        <xsl:value-of select="util:getmap($map,$item-id)"/>
    </xsl:template>


</xsl:stylesheet>


