package
{
	import feathers.themes.TopcoatLightMobileTheme;
	import feathers.controls.TextArea;
	import feathers.skins.ImageSkin;
	import feathers.controls.TextInputState;

	/** Removes the setting of TextArea.textEditorFactory */
	public class TopcoatLightMobileThemeMod extends TopcoatLightMobileTheme
	{
		override protected function setTextAreaStyles(textArea:TextArea):void
		{
			this.setScrollerStyles(textArea);

			var skin:ImageSkin = new ImageSkin(this.textInputBackgroundEnabledTexture);
			skin.disabledTexture = this.textInputBackgroundDisabledTexture;
			skin.setTextureForState(TextInputState.FOCUSED, this.textInputBackgroundFocusedTexture);
			skin.setTextureForState(TextInputState.ERROR, this.textInputBackgroundErrorTexture);
			skin.scale9Grid = TEXT_INPUT_SCALE9_GRID;
			skin.width = this.wideControlSize;
			skin.height = this.wideControlSize;
			textArea.backgroundSkin = skin;

			textArea.fontStyles = this.darkScrollTextFontStyles.clone();
			textArea.disabledFontStyles = this.darkScrollTextDisabledFontStyles.clone();

			textArea.promptFontStyles = this.darkFontStyles.clone();
			textArea.promptDisabledFontStyles = this.darkDisabledFontStyles.clone();

			textArea.innerPadding = this.smallGutterSize;
		}
	}
}