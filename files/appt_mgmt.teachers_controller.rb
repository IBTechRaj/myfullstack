...
...

def upcoming_classes_one_to_one
    begin
        @language121 = @teacher.language121_classes.where("class_date == ? AND status == ?", Date.today, 2)
        @group_classes = @teacher.language_classes.where ("class_date == ?", Date.today)

        if params[:data][:startdate].present? && params[:data][:enddate].present?
            @language121 = @teacher.language121_classes.where("class_date >= ? AND classs_date <= ? AND status = ?",
            params[:data][:startdate], params[:data][:enddate], 2)

             @group_classes = @teacher.language_classes.where("class_date >= ? AND classs_date <= ? ",
            params[:data][:startdate], params[:data][:enddate])

        rescue
            @language121 = [] unless @language121.present?
            @group_classes=[] unless @group_classes.present?
        end

        total = BxBlockAppointmentManagement::Language121Serializer.new(@language121).serializable_hash,
        TeacherGroupClassSerializer.new(@group_classes).serializable_hash

        render json: total
    end


    def accept_121_class
        @language121 = AccountBlock::Language121Class.find(params[:id])
        @language121.update(teacher_id: @teacher.id)
        @language121.update(status: 'accepted')
        emailtime = @language121.class_time - 24.hours
        BxBlockNotifications::TeacherClassReminderMailer.teacher_class_reminder_notification(@teacher, @language121.class_date, @language121.class_time, @language121.class_type).deliver_later(wait_until: emailtime)
end