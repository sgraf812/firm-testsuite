<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="html" indent="yes"
              doctype-public="-//W3C//DTD HTML 4.01//EN"
	            doctype-system="http://www.w3.org/TR/html4/strict.dtd"/>

	<xsl:template name="resultcell" match="result/*/*">
		<xsl:element name="div">
			<xsl:if test="contains(text(), 'ok')">
				<xsl:attribute name="style">background-color: green; color: white;</xsl:attribute>
			</xsl:if>
			<xsl:if test="contains(text(), 'failed')">
				<xsl:attribute name="style">background-color: red; color: white;</xsl:attribute>
			</xsl:if>
			<xsl:if test="contains(text(), 'missing')">
				<xsl:attribute name="style">background-color: black; color: white;</xsl:attribute>
			</xsl:if>
			<xsl:value-of select="text()"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="/">
		<html>
			<head>
				<title>Results</title>
			</head>
			<body>
				OLD: <xsl:value-of select="/results/files/OLD"/><br/>
				NEW: <xsl:value-of select="/results/files/NEW"/><br/><br/>
				<table>
					<tr>
						<th>Name</th>
						<th>Compile</th>
						<th>Link</th>
						<th>GCC Compile</th>
						<th>GCC Run</th>
						<th>Firm Run</th>
						<th>Results</th>
					</tr>
					<xsl:for-each select="/results/section">
						<tr>
						    <th colspan="7" style="background-color: yellow; color: black;"><xsl:value-of select="@name"/></th>
						</tr>
						<xsl:for-each select="result">
							<tr>
								<th rowspan="2">
									<xsl:element name="a">
										<xsl:attribute name="href">buildresult_<xsl:value-of select="@name"/>.txt</xsl:attribute>
										<xsl:value-of select="@name"/>
									</xsl:element>
								</th>
								<td><xsl:apply-templates select="OLD/compile"/></td>
								<td><xsl:apply-templates select="OLD/link"/></td>
								<td><xsl:apply-templates select="OLD/gcc_compile"/></td>
								<td><xsl:apply-templates select="OLD/gcc_run"/></td>
								<td><xsl:apply-templates select="OLD/firm_run"/></td>
								<td><xsl:apply-templates select="OLD/diff"/></td>
							</tr>
							<tr>
								<td><xsl:apply-templates select="NEW/compile"/></td>
								<td><xsl:apply-templates select="NEW/link"/></td>
								<td><xsl:apply-templates select="NEW/gcc_compile"/></td>
								<td><xsl:apply-templates select="NEW/gcc_run"/></td>
								<td><xsl:apply-templates select="NEW/firm_run"/></td>
								<td><xsl:apply-templates select="NEW/diff"/></td>
							</tr>
							<tr>
							    <th colspan="7"> </th>
							</tr>
						</xsl:for-each>
					</xsl:for-each>
				</table>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>
