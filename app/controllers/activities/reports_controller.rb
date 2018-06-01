module Activities
  class ReportsController < ApplicationController
    def new
      @report = Report.new from_date: from_date,
                           to_date: to_date

      respond_to do |format|
        format.html { }
        format.pdf do
          render pdf: filename, orientation: :landscape, zoom: 0.65, disposition: :attachment
        end
      end
    end

    private

    def filename
      I18n.t 'activities.reports.report.filename', from: I18n.l(from_date, format: :short),
                                                    to: I18n.l(to_date, format: :short)
    end

    def from_date
      if params.dig(:activities_report, :from_date)
        Date.parse(report_params[:from_date])
      else
        Date.current.beginning_of_month
      end
    end

    def to_date
      if params.dig(:activities_report, :to_date)
        Date.parse(report_params[:to_date])
      else
        Date.current.end_of_month
      end
    end

    def report_params
      params.require(:activities_report).permit(:from_date, :to_date)
    end
  end
end
