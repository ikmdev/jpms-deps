package dev.ikm.komet.reasoner;

import com.google.auto.service.AutoService;
import org.eclipse.collections.api.factory.Lists;
import org.eclipse.collections.api.list.ImmutableList;
import dev.ikm.komet.framework.KometNode;
import dev.ikm.komet.framework.KometNodeFactory;
import dev.ikm.komet.framework.activity.ActivityStream;
import dev.ikm.komet.framework.activity.ActivityStreamOption;
import dev.ikm.komet.framework.activity.ActivityStreams;
import dev.ikm.komet.framework.preferences.Reconstructor;
import dev.ikm.komet.framework.view.ObservableViewNoOverride;
import dev.ikm.komet.preferences.KometPreferences;
import dev.ikm.tinkar.common.id.PublicIdStringKey;

@AutoService(KometNodeFactory.class)
public class ReasonerResultsNodeFactory implements KometNodeFactory {
    protected static final String STYLE_ID = ReasonerResultsNode.STYLE_ID;
    protected static final String TITLE = ReasonerResultsNode.TITLE;

    @Override
    public void addDefaultNodePreferences(KometPreferences nodePreferences) {

    }

    @Override
    public ReasonerResultsNode create(ObservableViewNoOverride windowView, KometPreferences nodePreferences) {
        return reconstructor(windowView, nodePreferences);
    }

    @Reconstructor
    public static ReasonerResultsNode reconstructor(ObservableViewNoOverride windowView, KometPreferences nodePreferences) {
        return new ReasonerResultsNode(windowView.makeOverridableViewProperties(), nodePreferences);
    }

    @Override
    public Class<? extends KometNode> kometNodeClass() {
        return ReasonerResultsNode.class;
    }

    @Override
    public ImmutableList<PublicIdStringKey<ActivityStream>> defaultActivityStreamChoices() {
        return Lists.immutable.of(ActivityStreams.REASONER);
    }

    @Override
    public ImmutableList<PublicIdStringKey<ActivityStreamOption>> defaultOptionsForActivityStream(PublicIdStringKey<ActivityStream> streamKey) {
        if (streamKey.equals(ActivityStreams.REASONER)) {
            return Lists.immutable.of(ActivityStreamOption.PUBLISH.keyForOption());
        }
        return Lists.immutable.empty();
    }

    @Override
    public String getMenuText() {
        return TITLE;
    }

    @Override
    public String getStyleId() {
        return STYLE_ID;
    }
}