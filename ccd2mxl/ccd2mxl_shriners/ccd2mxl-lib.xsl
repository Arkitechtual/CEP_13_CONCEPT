<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:util="http://www.browsersoft.com/">

    <xsl:template name="get-code-display">
        <xsl:param name="code-tag"/>
        <xsl:choose>
            <xsl:when test="normalize-space($code-tag/originalText) != ''">
                <xsl:value-of select="$code-tag/originalText"/>
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
            <xsl:when test="$value-tag/@code">
                <xsl:value-of select="$value-tag/@code"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value-tag"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="get-provider-name">
        <xsl:param name="name-tag"/>
        <xsl:value-of select="$name-tag/family"/>
        <xsl:if test="$name-tag/given !=''">
            <xsl:text>, </xsl:text>
            <xsl:for-each select="$name-tag/given">
                <xsl:value-of select="."/>
                <xsl:text> </xsl:text>
            </xsl:for-each>
        </xsl:if>
        <xsl:if test="$name-tag/suffix">
            <xsl:text> </xsl:text>
            <xsl:value-of select="$name-tag/suffix"/>
        </xsl:if>
    </xsl:template>

    <xsl:template name="get-value-units">
        <xsl:param name="valueRef"/>
        <xsl:variable name="unitAttribute" select="$valueRef/@unit"/>
        <xsl:choose>
            <xsl:when test="$unitAttribute != '1'">
                <xsl:value-of select="$unitAttribute"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="normalize-space($valueRef/translation/originalText)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="get-content-display">
        <xsl:param name="tag-id"/>
        <xsl:param name="contentMap"/>
        <xsl:value-of select="util:getmap($contentMap,$tag-id)"/>
    </xsl:template>

    <xsl:template name="get-source-tag">
        <xsl:param name="globalAuthor"/>
        <xsl:param name="author-tag" required="no"/>
        <xsl:choose>
            <xsl:when test="$author-tag and contains($author-tag/assignedAuthor/representedOrganization/id/@root,'.')">
                <xsl:value-of select="$author-tag/assignedAuthor/representedOrganization/id/@root"/>
            </xsl:when>
            <xsl:when test="$author-tag and $author-tag/assignedAuthor/representedOrganization/name != ''">
                <xsl:value-of select="$author-tag/assignedAuthor/representedOrganization/name"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$globalAuthor"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="create-comments">
        <xsl:param name="contentMap"/>
        <xsl:param name="node"/>

        <xsl:choose>
            <xsl:when test="$node/entryRelationship/act[code/@code='48767-8']/text/reference/@value != ''">
                <xsl:for-each select="$node/entryRelationship/act[code/@code='48767-8']">
                    <xsl:element name="COMMENTS">
                        <xsl:call-template name="get-content-display">
                            <xsl:with-param name="contentMap" select="$contentMap"/>
                            <xsl:with-param name="tag-id" select="translate(./text/reference/@value,'#','')"/>
                        </xsl:call-template>
                    </xsl:element>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="COMMENTS">
                    <xsl:value-of select="$node/entryRelationship/act[code/@code='48767-8']/text"/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="get-qty">
        <xsl:param name="qty"/>

        <xsl:choose>
            <xsl:when test="$qty/@value != ''">
                <xsl:value-of select="$qty/@value"/>
            </xsl:when>
            <xsl:when test="$qty/low/@value != ''">
                <xsl:value-of select="$qty/low/@value"/>
            </xsl:when>
            <xsl:when test="$qty/center/@value != ''">
                <xsl:value-of select="$qty/center/@value"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$qty/high/@value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="get-qty-unit">
        <xsl:param name="qty-unit"/>

        <xsl:choose>
            <xsl:when test="$qty-unit/@unit != ''">
                <xsl:value-of select="$qty-unit/@unit"/>
            </xsl:when>
            <xsl:when test="$qty-unit/low/@unit != ''">
                <xsl:value-of select="$qty-unit/low/@unit"/>
            </xsl:when>
            <xsl:when test="$qty-unit/center/@unit != ''">
                <xsl:value-of select="$qty-unit/center/@unit"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$qty-unit/high/@unit"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>


