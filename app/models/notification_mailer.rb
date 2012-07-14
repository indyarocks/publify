class NotificationMailer < ActionMailer::Base
  helper :mail
  layout nil

  def article(article, user)
    setup(user, article)
    @subject = "[#{article.blog.blog_name}] New article: #{article.title}"
    @article = article
    build_mail
  end

  def comment(comment, user)
    setup(user, comment)
    @subject = "[#{comment.blog.blog_name}] New comment on #{comment.article.title}"
    @article = comment.article
    @comment = comment
    build_mail
  end

  def trackback(sent_at = Time.now)
    setup(user, trackback)
    @subject = "[#{trackback.blog.blog_name}] New trackback on #{trackback.article.title}"
    @article = trackback.article
    @trackback = trackback
    build_mail
  end

  def notif_user(user)
    @user = user
    @blog = Blog.default
    @recipients = user.email
    @from = Blog.default.email_from
    headers['X-Mailer'] = "Typo #{TYPO_VERSION}"
    build_mail
  end

  private

  def setup(user, content)
    @user = user
    @blog = content.blog
    @recipients = user.email
    @from = content.blog.email_from
    headers['X-Mailer'] = "Typo #{TYPO_VERSION}"
  end

  def build_mail
    mail(from: @from,
         to: @recipients,
         subject: @subject)
  end
end
