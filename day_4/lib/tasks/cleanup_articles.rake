namespace :articles do
  desc "Remove articles that have been reported 6 or more times"
  task cleanup_reported: :environment do
    puts "Starting cleanup of heavily reported articles..."
    
    articles_to_remove = Article.where('reports_count >= ?', 6)
    count = articles_to_remove.count
    
    if count > 0
      puts "Found #{count} article(s) to remove"
      
      articles_to_remove.each do |article|
        puts "Removing article: #{article.title} (ID: #{article.id}) - Reports: #{article.reports_count}"
        article.destroy
      end
      
      puts "Cleanup completed successfully! Removed #{count} articles"
    else
      puts "No articles found with 6+ reports"
    end
  end
end