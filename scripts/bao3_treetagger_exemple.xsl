<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="html" encoding="utf-8"/>
    <xsl:template match="/">
        <html>
            <head>
                <style>
                    body {font-family: "Times New Roman", times,serif;}
                    patron {background-color: rgba(255, 166, 0, 0.384);}
                    lemme {font-size:10px;font-weight:bold;color:#d9534f;}
                    type {font-size: 10px;font-weight:bold;color:rgba(0, 0, 255, 0.5);}
                </style>
            </head>
            <body>
                <h1 align="center">Contenus étiquetés avec le patron NOM+ADJ</h1>
                <table border="1" align="center">
                    <tr>
                        <th>N°</th>
                        <th>TITRE</th>
                        <th>DESCRIPTION</th>
                    </tr>
                    <xsl:apply-templates select="//item"/>
                </table>
            </body>
        </html>
    </xsl:template>
    <xsl:template match="item">
        <tr>
            <td><xsl:value-of select="./@number"/></td>
            <td>
                <xsl:apply-templates select="./titre/article/element"/>
            </td>
            <td>
                <xsl:apply-templates select="./description/article/element"/>
            </td>
        </tr>     
    </xsl:template>
    
    <xsl:template match="item/titre/article/element">
        <xsl:for-each select=".">
            <xsl:choose>
                <xsl:when test="./data[contains(text(),'NOM')] and following-sibling::element[1]/data[contains(text(),'ADJ')] and following-sibling::element[2]/data[contains(text(),'NOM')]">
                    <patron><xsl:value-of select="./data[3]"/></patron> 
                    [<lemme><xsl:value-of select="./data[2]"/></lemme>|<type><xsl:value-of select="./data[1]"/></type>]
                    <xsl:text> </xsl:text>
                </xsl:when>
                <xsl:when test="./data[contains(text(),'ADJ')] and preceding-sibling::element[1]/data[contains(text(),'DET')] and following-sibling::element[1]/data[contains(text(),'NOM')]">
                    <patron><xsl:value-of select="./data[3]"/></patron> 
                    [<lemme><xsl:value-of select="./data[2]"/></lemme>|<type><xsl:value-of select="./data[1]"/></type>]
                    <xsl:text> </xsl:text>
                </xsl:when>
                <xsl:when test="./data[contains(text(),'NOM')] and preceding-sibling::element[1]/data[contains(text(),'ADJ')] and preceding-sibling::element[2]/data[contains(text(),'DET')]">
                    <patron><xsl:value-of select="./data[3]"/></patron> 
                    [<lemme><xsl:value-of select="./data[2]"/></lemme>|<type><xsl:value-of select="./data[1]"/></type>]
                    <xsl:text> </xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="./data[3]"/>
                    <xsl:text> </xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="item/description/article/element">
        <xsl:for-each select=".">
            <xsl:choose>
                <xsl:when test="./data[contains(text(),'DET')] and following-sibling::element[1]/data[contains(text(),'ADJ')] and following-sibling::element[2]/data[contains(text(),'NOM')]">
                    <patron><xsl:value-of select="./data[3]"/></patron> 
                    [<lemme><xsl:value-of select="./data[2]"/></lemme>|<type><xsl:value-of select="./data[1]"/></type>]
                    <xsl:text> </xsl:text>
                </xsl:when>
                <xsl:when test="./data[contains(text(),'ADJ')] and preceding-sibling::element[1]/data[contains(text(),'DET')] and following-sibling::element[1]/data[contains(text(),'NOM')]">
                    <patron><xsl:value-of select="./data[3]"/></patron> 
                    [<lemme><xsl:value-of select="./data[2]"/></lemme>|<type><xsl:value-of select="./data[1]"/></type>]
                    <xsl:text> </xsl:text>
                </xsl:when>
                <xsl:when test="./data[contains(text(),'NOM')] and preceding-sibling::element[1]/data[contains(text(),'ADJ')] and preceding-sibling::element[2]/data[contains(text(),'DET')]">
                    <patron><xsl:value-of select="./data[3]"/></patron> 
                    [<lemme><xsl:value-of select="./data[2]"/></lemme>|<type><xsl:value-of select="./data[1]"/></type>]
                    <xsl:text> </xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="./data[3]"/>
                    <xsl:text> </xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>         