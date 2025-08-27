<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:include href="tagged-pdf.xsl"/>
  <xsl:template match="/Document|/DocumentFragment">
    <html>
      <head><link rel="stylesheet" href="iso32000.css"/></head>
      <body>
        <xsl:apply-templates/>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
