<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="1.0">
    <xsl:output method="html" encoding="utf-8"/>
    <xsl:template match="/">
        <html>
            <head>
                <style>
                    patron {
                    background-color: rgba(255, 166, 0, 0.384);
                    }
                    type {
                        font-weight: bold;
                        color: rgba(0, 0, 255, 0.5);
                    }</style>
            </head>
            <body>
                <h1 align="center">(TITRE) Contenus étiquetés avec le patron NC ADJ</h1>
                <xsl:apply-templates select="/" mode="titre"/>
                <h1 align="center">(DESC) Contenus étiquetés avec le patron NC ADJ</h1>
                <xsl:apply-templates select="/" mode="des"/>
            </body>
        </html>
    </xsl:template>
    <xsl:template match="/" mode="titre">
        <xsl:for-each select="//p">
            <xsl:if test="./item[last()]/a[2] != '§'">
                <xsl:for-each select="./item">
                    <xsl:choose>
                        <xsl:when test="(./a[4] = 'NC') and following-sibling::item[1]/a[4] = 'ADJ'">
                            <patron>
                                <xsl:value-of select="./a[2]"/>
                            </patron> [ <type>
                                <xsl:value-of select="./a[4]"/>
                            </type> ] <xsl:text> </xsl:text>
                        </xsl:when>
                        <xsl:when
                            test="./a[4][text() = 'ADJ'] and preceding-sibling::item[1]/a[4][text() = 'NC']">
                            <patron>
                                <xsl:value-of select="./a[2]"/>
                            </patron> [ <type>
                                <xsl:value-of select="./a[4]"/>
                            </type> ] <xsl:text> </xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="./a[2]"/>
                            <xsl:text> </xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="/" mode="des">
        <xsl:for-each select="//p">
            <xsl:if test="./item[last()]/a[2] = '§'">
                <xsl:for-each select="./item">
                    <xsl:choose>
                        <xsl:when test="(./a[4] = 'NC') and following-sibling::item[1]/a[4] = 'ADJ'">
                            <patron>
                                <xsl:value-of select="./a[2]"/>
                            </patron> [ <type>
                                <xsl:value-of select="./a[4]"/>
                            </type> ] <xsl:text> </xsl:text>
                        </xsl:when>
                        <xsl:when
                            test="./a[4][text() = 'ADJ'] and preceding-sibling::item[1]/a[4][text() = 'NC']">
                            <patron>
                                <xsl:value-of select="./a[2]"/>
                            </patron> [ <type>
                                <xsl:value-of select="./a[4]"/>
                            </type> ] <xsl:text> </xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="./a[2]"/>
                            <xsl:text> </xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
