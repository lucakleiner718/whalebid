module ApplicationHelper
	def addcustomjs(*files)
		content_for(:head_js) { javascript_include_tag(*files) }
	end
end
