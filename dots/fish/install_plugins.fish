#!/usr/bin/env fish

echo "👉 Installing Fisher..."
curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher

echo "👉 Installing plugins..."
fisher install \
    jorgebucaran/nvm.fish \
    jethrokuan/z \
    oh-my-fish/theme-bobthefish \
    ilancosman/tide@v6 \
    franciscolourenco/done \
    edc/bass \
    patrickf1/fzf.fish

echo "✅ All plugins installed!"

echo "⚠️ If you're using Tide, run 'tide configure' to set it up."
echo "💡 You may want to remove bobthefish or tide if you only want one prompt."
