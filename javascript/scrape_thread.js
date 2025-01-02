javascript:(function () {
  console.log("RUNNING BOOKMARKLET");
  async function extractSlackMessages() {
    const messages = [];
    let hasMore = true;
    let lastTimestamp;

    try {
      const messageElements = document.querySelector(".p-view_contents.p-view_contents--secondary").querySelectorAll('.c-message_kit__message');

      messageElements.forEach(msg => {
        const timestamp = msg.querySelector('.c-timestamp')?.getAttribute('data-ts');
        if (timestamp === lastTimestamp) return;

        const sender = msg.querySelector('.c-message__sender')?.textContent?.trim();
        const content = msg.querySelector('.p-rich_text_block')?.textContent?.trim();
        const reactions = Array.from(msg.querySelectorAll('.c-reaction_bar .c-reaction'))
              .map(reaction => ({
                emoji: reaction.querySelector('.c-reaction__emoji')?.getAttribute('data-colon'),
                count: parseInt(reaction.querySelector('.c-reaction__count')?.textContent || '0')
              }));

        if (sender && content && !messages.some(m =>
          m.timestamp === new Date(parseFloat(timestamp) * 1000).toISOString() &&
            m.sender === sender &&
            m.content === content
        )) {
          messages.push({
            timestamp: new Date(parseFloat(timestamp) * 1000).toISOString(),
            sender,
            content,
            reactions
          });
        }
      });

      messages.sort((a, b) => new Date(a.timestamp) - new Date(b.timestamp));

      const threadTs = messages[0]?.timestamp || "timestamp";
      const orgName = document.querySelector(".p-ia4_home_header_menu__team_name")?.textContent?.trim() || "org";
      const channelName = document.querySelector('.p-view_header__text')?.textContent?.trim() || 'channel';
      const blob = new Blob([JSON.stringify(messages, null, 2)], { type: 'application/json' });
      const url = URL.createObjectURL(blob);
      const a = document.createElement('a');
      a.href = url;
      a.download = `slack-${orgName}-${channelName}-${threadTs}-export.json`;
      a.click();
      URL.revokeObjectURL(url);

      console.log(`Exported ${messages.length} messages`);
    } catch (error) {
      console.error('Error extracting messages:', error);
    }
  };
  extractSlackMessages();
})();
