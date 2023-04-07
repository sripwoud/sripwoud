flatpakrefs=(
 org.signal.Signal
 com.discordapp.Discord
 com.tutanota.Tutanota
 org.gnome.DejaDup
 org.signal.Signal
 rest.insomnia.Insomnia
 com.github.jeromerobert.pdfarranger
 org.standardnotes.standardnotes
 com.calibre_ebook.calibre
 com.slack.Slack
)

for flatpakref in ${flatpakrefs[@]};do
  flatpak install "$flatpakref" -y
done

